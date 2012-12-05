classdef Fit
  %This Class implements a fit, using a general model of a
  %function with unknown coefficcients, and data vectors the coeeffiecients
  %can be calculated.
  properties(SetAccess=private)
      name
      fitModel
      fitResult
      gof
      xVector
      yVector  
  end
  %name - the name of the fit
  %fitModel - the function model. to see model options, type "cflibhelp"
  methods
      function self=Fit(name,fitModel,xVector,yVector)
      %constructs a fit objects and goodness of fit struct, and stores the fields 
      %that generated it.
      %**to see possible options for fitModel, type cflibhelp
          if nargin<2
              error('must recieve at least two parametes - (name,Fit Model,x vector,y vector)')
          end
          if ~strcmp(class(name),'char')
              error('the name must be a char')
          end
          if ~strcmp(class(fitModel),'char')
              error('Fit Model must be either type "char"')
          end
          if ~strcmp(class(xVector),'Vector')
              error('x data must be a Vector variable')
          elseif ~strcmp(class(yVector),'Vector')
              error('y data must be a Vector variable')
          end 
          self.name=name;
          self.xVector=xVector;
          self.yVector=yVector;
          self.fitModel=fittype(fitModel);
          [self.fitResult self.gof]=fit(xVector.getNum,yVector.getNum,self.fitModel);

      end

      function disp(self)
          fprintf('$Fit Model name "%s":\n',self.name);
          fprintf('Fit Result:\n')
          disp(self.fitResult);
          fprintf('Goodness Of Fit:\n');
          disp(self.gof);         
      end 
      function name=getName(self)
      %get the name of the fit
          name=self.name;
      end   
      function xVector=getXvector(self)
      %get the name of the x field of the fit
          xVector=self.xVector;
      end
      function yVector=getYvector(self)
      %get the name of the x field of the fit
          yVector=self.yVector;
      end
      function model=getModel(self)
      %get the model of the fit
          model=self.fitModel;
      end
     function gof=getgof(self)
      %get the goodness of the fit
          gof=self.gof;
     end
     function fitResult=getFit(self)
      %get the fit result
          fitResult=self.fitResult;
     end
          
           
  end
end  