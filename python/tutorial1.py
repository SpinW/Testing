import numpy as np
import transplant
import sys


class TransplantInterface():

    def __init__(self, deployFile=None, session=None):
        self.isDeployed = False
        if session is None:
            if deployFile is not None:
                self.matlab = transplant.Matlab(executable=deployFile)
                self.isDeployed = True
            else:
                self.matlab = transplant.Matlab()
        else:
            self.matlab = session

    def __enter__(self):
        return self.matlab

    def __exit__(self, exc_type, exc_val, exc_tb):
        if ((exc_type is not None) and
                (exc_val is not None) and
                (exc_tb is not None)):
            self.matlab.close('all')
            self.matlab.exit()
            print('Killed MATLAB due to error. Exiting....')
            exit(1)

    def exit(self):
        self.matlab.close('all')
        self.matlab.exit()

def recursiveStruct(D):
    for key in D:
        if type(D[key]) is dict:
            D[key] = recursiveStruct(D[key])
    D = transplant.MatlabStruct(D)
    return D

def tutorial1(interpreter):

    with interpreter as matlab:
        FMchain = matlab.spinw()
        FMchain.genlattice(lat_const = np.array([3., 8., 8.]),
                           angled = np.array([90., 90., 90.]))
        FMchain.addatom(r = np.array([0., 0., 0.]),
                        S = 1.,
                        label = 'MCu1',
                        color = 'blue')
        FMchain.plot(range = np.array([3., 1., 1.]))
        matlab.drawnow()

        FMchain.gencoupling(maxDistance=7.)

        FMchain.addmatrix(value = -1.*np.eye(3),
                          label = 'Ja',
                          color = 'green')
        FMchain.addcoupling(mat = 'Ja', bond = 1.)

        FMchain.plot(range = np.array([3., 0.2, 0.2,]),
                     cellMode = 'none',
                     baseMode = 'none')

        if interpreter.isDeployed:
            matlab.waitforgui()
        else:
            matlab.drawnow()

        FMchain.genmagstr(mode = 'direct',
                          k = np.array([0., 0., 0.]),
                          n = np.array([1., 0., 0.]),
                          S = np.array([[0.], [1.], [0.]]))

        print(FMchain.energy())

        FMSpec = FMchain.spinwave([np.array([0., 0., 0.]), np.array([1., 0., 0.])],
                                  hermit = False)
        FMSpec = recursiveStruct(FMSpec)

        FMSpec = matlab.sw_neutron(FMSpec)
        FMSpec = recursiveStruct(FMSpec)

        FMSpec = matlab.sw_egrid(FMSpec, component = 'Sperp')
        FMSpec = recursiveStruct(FMSpec)

        f = matlab.figure()
        matlab.sw_plotspec(FMSpec, mode = 1., colorbar = False)
        if interpreter.isDeployed:
            matlab.waitforgui()
        else:
            matlab.drawnow()

        f = matlab.figure()
        matlab.sw_plotspec(FMSpec, mode = 2)
        if interpreter.isDeployed:
            matlab.waitforgui()
        else:
            matlab.drawnow()

        FMpowspec = FMchain.powspec(np.linspace(0, 2.5, 100),
                                    Evect = np.linspace(0, 4.5, 250),
                                    nRand = 1000.,
                                    hermit = False)
        FMpowspec = recursiveStruct(FMpowspec)

        matlab.sw_plotspec(FMpowspec, dE=0.1)
        if interpreter.isDeployed:
            matlab.waitforgui()
        else:
            matlab.drawnow()

if __name__  == "__main__":

    deployFile = None
    if (len(sys.argv) == 2):
        deployFile = sys.argv[2]

    interpreter = TransplantInterface(deployFile)
    tutorial1(interpreter)
    interpreter.exit()
    exit(0)