classdef genLattice < matlab.unittest.TestCase
    %CREATETEST Summary of this class goes here
    %   Detailed explanation goes here
    
    
    properties (MethodSetupParameter)
        seed = {0};
    end
        
    properties (TestParameter)
        
        spgrp = struct('Triclinic',1:2,...
                       'Monoclinic',3:15,...
                       'Orthorhombic',16:74,...
                       'Tetragonal',75:142,...
                       'Trigonal',143:167,...
                       'Hexagonal',168:194,...
                       'Cubic',195:230);
                   
        angled = struct('Triclinic',180*rand(2,3),... al!be!ga
                       'Monoclinic',[90*ones(13,1),90+30*(rand(13,1)-0.5) ,90*ones(13,1)],...
                       'Orthorhombic',90*ones(59,3),...
                       'Tetragonal',90*ones(68,3),...
                       'Trigonal',[90*ones(25,2) 120*ones(25,1)],...
                       'Hexagonal',[90*ones(27,2) 120*ones(27,1)],...
                       'Cubic',90*ones(36,3));
                   
           angle = struct('Triclinic',pi*rand(2,3),... al!be!ga
                       'Monoclinic',[0.5*pi*ones(13,1),0.5*pi+pi*(rand(13,1)-0.5)/6 ,0.5*pi*ones(13,1)],...
                       'Orthorhombic',0.5*pi*ones(59,3),...
                       'Tetragonal',0.5*pi*ones(68,3),...
                       'Trigonal',[0.5*pi*ones(25,2) 2*pi*ones(25,1)/3],...
                       'Hexagonal',[0.5*pi*ones(27,2) 2*pi*ones(27,1)/3],...
                       'Cubic',0.5*pi*ones(36,3));
                   
        latt_const = struct('Triclinic',10*rand(2,3),... al!be!ga
                       'Monoclinic',10*rand(13,3),...
                       'Orthorhombic',10*rand(59,3),...
                       'Tetragonal',[repmat(10*rand(68,1),1,2) 10*rand(68,1)],...
                       'Trigonal',[repmat(10*rand(25,1),1,2) 10*rand(25,1)],...
                       'Hexagonal',[repmat(10*rand(27,1),1,2) 10*rand(27,1)],...
                       'Cubic',repmat(10*rand(36,1),1,3));
    end
    
    methods (TestMethodSetup)
        function MethodSetup(testCase, seed)
            orig = rng;
            testCase.addTeardown(@rng, orig)
            rng(seed)
        end
    end
    
    methods (Test, ParameterCombination='sequential')
        function testLatticeRad(testCase,spgrp,angle,latt_const)
            j = 1;
            for spg = spgrp
               s = spinw;
               s.genlattice('lat_const',latt_const(j,:),'angle',angle(j,:),'spgr',spg)
               testCase.verifyEqual(s.lattice.angle,angle(j,:))
               testCase.verifyEqual(s.lattice.lat_const,latt_const(j,:))
               j = j + 1;
            end
        end
        
        function testLatticeDeg(testCase,spgrp,angled,latt_const)
            j = 1;
            for spg = spgrp
               s = spinw;
               s.genlattice('lat_const',latt_const(j,:),'angled',angled(j,:),'spgr',spg)
               testCase.verifyEqual(s.lattice.angle,pi*angled(j,:)/180)
               testCase.verifyEqual(s.lattice.lat_const,latt_const(j,:))
               j = j + 1;
            end
        end
        
    end
end