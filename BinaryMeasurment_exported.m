classdef BinaryMeasurment_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        UIORIGINAL                   matlab.ui.control.UIAxes
        UIBINARY                     matlab.ui.control.UIAxes
        RedplaneswitchSwitchLabel    matlab.ui.control.Label
        RedplaneswitchSwitch         matlab.ui.control.Switch
        GreenplaneswitchSwitchLabel  matlab.ui.control.Label
        GreenplaneswitchSwitch       matlab.ui.control.Switch
        BlueplaneswitchSwitchLabel   matlab.ui.control.Label
        BlueplaneswitchSwitch        matlab.ui.control.Switch
        LOADIMAGEButton              matlab.ui.control.Button
        GetdiameterandalgorithmexplenetionButton  matlab.ui.control.Button
        Label                        matlab.ui.control.Label
        EditField                    matlab.ui.control.NumericEditField
        TextAreaLabel                matlab.ui.control.Label
        TextArea                     matlab.ui.control.TextArea
        UIRED                        matlab.ui.control.UIAxes
        UIGREEN                      matlab.ui.control.UIAxes
        UIBLUE                       matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        pushed % if LOAD IMAGE button is pushed
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            global image1
            
            image1_R = image1(:,:,1);
            image1_G = image1(:,:,2);
            image1_B = image1(:,:,3);
            
             histr = histogram(app.UIRED,image1_R, 'FaceColor', [1 0 0], 'EdgeColor', "none", 'Visible', "off");
             histg = histogram(app.UIGREEN, image1_G, 'FaceColor', [0 1 0], 'EdgeColor',"none", 'Visible',"off");
             histb = histogram(app.UIBLUE, image1_B, 'FaceColor', [0 0 1], 'EdgeColor',"none", 'Visible',"off");
            
             app.RedplaneswitchSwitch.UserData.line = histr;
             app.GreenplaneswitchSwitch.UserData.line = histg;
             app.BlueplaneswitchSwitch.UserData.line = histb;
        
        end

        % Button pushed function: LOADIMAGEButton
        function LOADIMAGEButtonPushed(app, event)
            global image1
            global d
            
            %[filename pathname] = uigetfile({'*.jpg'}, 'File Selector');
            
            %fullpathname = strcat(pathname, filename);
            image1 = imread("https://content.fortune.com/wp-content/uploads/2017/01/118960626.jpg");
            value = app.LOADIMAGEButton.Interruptible; 
            %image1 = imread(fullpathname);
            image1_B = image1(:,:,3);
            % Convert our image1 to binary using the Blue-plane
            img_grayscale = imadjust(image1_B);
            [row, col] = size(img_grayscale);
            % manuly converting the image1 to black-white
            for i = 1:row
                for j = 1:col
                    if (img_grayscale(i,j) < 100) 
                        img_grayscale(i,j) = 0;
                    else
                        img_grayscale(i,j) = 255;
                    end
                end
            end
            
            BW = img_grayscale;
            % pre-proccessing our image 
            fill = imfill(BW, 'holes');
            se = strel('disk', 10);
            BWnew = imopen(fill,se);
            % converting our binary unit8 image to logical matrix 
            BWnew = (BWnew >= 100);
            
            length = regionprops(BWnew, 'MajorAxisLength');
            length = struct2cell(length);
            d = cell2mat(length(1,1));
            
            imshow(image1, 'parent', app.UIORIGINAL);
            imshow(BWnew, 'parent', app.UIBINARY);
            app.pushed = true;
        end

        % Value changed function: RedplaneswitchSwitch
        function RedplaneswitchSwitchValueChanged(app, event)
            if app.pushed
                value = app.RedplaneswitchSwitch.Value;
                if strcmpi('on',value)
                    event.Source.UserData.line.Visible = 'on';
                else
                    event.Source.UserData.line.Visible = 'off';
                end
            end
        end

        % Value changed function: GreenplaneswitchSwitch
        function GreenplaneswitchSwitchValueChanged(app, event)
            if app.pushed
                value = app.GreenplaneswitchSwitch.Value;
                if strcmpi('on',value)
                    event.Source.UserData.line.Visible = 'on';
                else
                    event.Source.UserData.line.Visible = 'off';
                
                end
            end
        end

        % Value changed function: BlueplaneswitchSwitch
        function BlueplaneswitchSwitchValueChanged(app, event)
            if app.pushed
                value = app.BlueplaneswitchSwitch.Value;
                if strcmpi('on',value)
                    event.Source.UserData.line.Visible = 'on';
                else
                    event.Source.UserData.line.Visible = 'off';
                
                end
            end
        end

        % Button pushed function: 
        % GetdiameterandalgorithmexplenetionButton
        function GetdiameterandalgorithmexplenetionButtonPushed(app, event)
            global d
            app.EditField.Value = d;
            app.TextArea.Value = "After generating our golf-ball image we can see from the Blue-plane histogram that the 3rd plane (blue) gives us the " + ...
                "highest contrast, so it will be easier to manualy convert the Blue-plane image to a binary image for diemter measurment using image-proccessing toolbox." + ...
                " Manuly measuring the golf ball diameter using built-in funciton 'imdistline' we get a value of 299.56";
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1048 795];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIORIGINAL
            app.UIORIGINAL = uiaxes(app.UIFigure);
            title(app.UIORIGINAL, 'Original Image')
            xlabel(app.UIORIGINAL, '')
            ylabel(app.UIORIGINAL, '')
            app.UIORIGINAL.FontWeight = 'bold';
            app.UIORIGINAL.Position = [1 484 448 287];

            % Create UIBINARY
            app.UIBINARY = uiaxes(app.UIFigure);
            title(app.UIBINARY, 'Binary Image')
            xlabel(app.UIBINARY, '')
            ylabel(app.UIBINARY, '')
            app.UIBINARY.Position = [1 195 448 287];

            % Create RedplaneswitchSwitchLabel
            app.RedplaneswitchSwitchLabel = uilabel(app.UIFigure);
            app.RedplaneswitchSwitchLabel.HorizontalAlignment = 'center';
            app.RedplaneswitchSwitchLabel.FontWeight = 'bold';
            app.RedplaneswitchSwitchLabel.Position = [510 602 104 22];
            app.RedplaneswitchSwitchLabel.Text = 'Red-plane switch';

            % Create RedplaneswitchSwitch
            app.RedplaneswitchSwitch = uiswitch(app.UIFigure, 'slider');
            app.RedplaneswitchSwitch.ValueChangedFcn = createCallbackFcn(app, @RedplaneswitchSwitchValueChanged, true);
            app.RedplaneswitchSwitch.FontWeight = 'bold';
            app.RedplaneswitchSwitch.Position = [538 639 45 20];

            % Create GreenplaneswitchSwitchLabel
            app.GreenplaneswitchSwitchLabel = uilabel(app.UIFigure);
            app.GreenplaneswitchSwitchLabel.HorizontalAlignment = 'center';
            app.GreenplaneswitchSwitchLabel.FontWeight = 'bold';
            app.GreenplaneswitchSwitchLabel.Position = [507 353 116 22];
            app.GreenplaneswitchSwitchLabel.Text = 'Green-plane switch';

            % Create GreenplaneswitchSwitch
            app.GreenplaneswitchSwitch = uiswitch(app.UIFigure, 'slider');
            app.GreenplaneswitchSwitch.ValueChangedFcn = createCallbackFcn(app, @GreenplaneswitchSwitchValueChanged, true);
            app.GreenplaneswitchSwitch.FontWeight = 'bold';
            app.GreenplaneswitchSwitch.Position = [541 390 45 20];

            % Create BlueplaneswitchSwitchLabel
            app.BlueplaneswitchSwitchLabel = uilabel(app.UIFigure);
            app.BlueplaneswitchSwitchLabel.HorizontalAlignment = 'center';
            app.BlueplaneswitchSwitchLabel.FontWeight = 'bold';
            app.BlueplaneswitchSwitchLabel.Position = [510 117 108 22];
            app.BlueplaneswitchSwitchLabel.Text = 'Blue-plane switch';

            % Create BlueplaneswitchSwitch
            app.BlueplaneswitchSwitch = uiswitch(app.UIFigure, 'slider');
            app.BlueplaneswitchSwitch.ValueChangedFcn = createCallbackFcn(app, @BlueplaneswitchSwitchValueChanged, true);
            app.BlueplaneswitchSwitch.FontWeight = 'bold';
            app.BlueplaneswitchSwitch.Position = [541 154 45 20];

            % Create LOADIMAGEButton
            app.LOADIMAGEButton = uibutton(app.UIFigure, 'push');
            app.LOADIMAGEButton.ButtonPushedFcn = createCallbackFcn(app, @LOADIMAGEButtonPushed, true);
            app.LOADIMAGEButton.FontWeight = 'bold';
            app.LOADIMAGEButton.Position = [500 715 130 30];
            app.LOADIMAGEButton.Text = 'LOAD IMAGE';

            % Create GetdiameterandalgorithmexplenetionButton
            app.GetdiameterandalgorithmexplenetionButton = uibutton(app.UIFigure, 'push');
            app.GetdiameterandalgorithmexplenetionButton.ButtonPushedFcn = createCallbackFcn(app, @GetdiameterandalgorithmexplenetionButtonPushed, true);
            app.GetdiameterandalgorithmexplenetionButton.FontWeight = 'bold';
            app.GetdiameterandalgorithmexplenetionButton.Position = [215 164 253 31];
            app.GetdiameterandalgorithmexplenetionButton.Text = 'Get diameter and algorithm explenetion';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Enable = 'off';
            app.Label.Position = [59 168 25 22];
            app.Label.Text = '';

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'numeric');
            app.EditField.Position = [59 168 140 22];

            % Create TextAreaLabel
            app.TextAreaLabel = uilabel(app.UIFigure);
            app.TextAreaLabel.HorizontalAlignment = 'right';
            app.TextAreaLabel.FontSize = 14;
            app.TextAreaLabel.FontWeight = 'bold';
            app.TextAreaLabel.Position = [47 131 68 22];
            app.TextAreaLabel.Text = 'Text Area';

            % Create TextArea
            app.TextArea = uitextarea(app.UIFigure);
            app.TextArea.FontSize = 14;
            app.TextArea.FontWeight = 'bold';
            app.TextArea.Position = [47 9 421 146];

            % Create UIRED
            app.UIRED = uiaxes(app.UIFigure);
            title(app.UIRED, 'Red-plane histogram')
            xlabel(app.UIRED, 'Pixels')
            ylabel(app.UIRED, 'Distribution')
            app.UIRED.FontWeight = 'bold';
            app.UIRED.Position = [663 516 386 229];

            % Create UIGREEN
            app.UIGREEN = uiaxes(app.UIFigure);
            title(app.UIGREEN, 'Green-plane histogram')
            xlabel(app.UIGREEN, 'Pixels')
            ylabel(app.UIGREEN, 'Distribution')
            app.UIGREEN.FontWeight = 'bold';
            app.UIGREEN.Position = [663 267 386 229];

            % Create UIBLUE
            app.UIBLUE = uiaxes(app.UIFigure);
            title(app.UIBLUE, 'Blue-plane histogram')
            xlabel(app.UIBLUE, 'Pixels')
            ylabel(app.UIBLUE, 'Distribution')
            app.UIBLUE.FontWeight = 'bold';
            app.UIBLUE.Position = [663 31 386 229];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = BinaryMeasurment_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end