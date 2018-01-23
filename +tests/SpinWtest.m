classdef SpinWtest < matlab.unittest.TestCase
    
    methods (TestClassSetup)
        function setup(testCase)
            % Cache the original path when we start
            testCase.addTeardown(@path, path);
            d = version; d = d(end-1:-1:end-6); d = d(end:-1:1);
            log_dir = fullfile(filesep,'tmp','Report');
            if exist(fullfile(log_dir,d),'dir') == 7
               rmdir(fullfile(log_dir,d)) 
               mkdir(fullfile(log_dir,d))
            else
                mkdir(fullfile(log_dir,d))
            end
            % Add necessary SpinW files to path if they arent already there
            if exist('spinw', 'file') ~= 2
                install_spinw('silent',true);
            end
        end
    end

    methods
        function h = figure(testCase, varargin)
            % figure - Helper for creating self-destroying figure
            %
            %   This method creates a new figure with the specified
            %   parameters and automatically adds a teardown function to
            %   the testCase so that it is certain to be destroyed even on
            %   test failure.
            %
            % USAGE:
            %   h = SpinWtest.figure(params)
            %
            % INPUTS:
            %   params: Parameter/Value Pairs, indicates properties to pass
            %           along to the figure for creation.
            %
            % OUTPUTS:
            %   h:      Handle, Handle to the generated figure object.
            %
            % Last Modified: 06-08-2015
            % Modified By: Jonathan Suever (suever@gmail.com)

            h = figure('Visible', 'off', varargin{:});

            % Add a teardown so that this automatically removed
            testCase.addTeardown(@()delete(h(ishandle(h))));
        end
    end
end
