classdef Func
  %This class implements a function. upon construction it calculates the
  %error propogation function.
  %dependencies: calcError function
  properties(SetAccess=private)
      name
      func
      funcError
  end
  %name - the name of the function
  %the function itself(stored as "sym")
  %the function Error(stored as "sym")
  methods
      function self=Func(name,func)
          if nargin<2
              error('must recieve at least two parametes - (name,function)')
          end
          if strcmp(class(name),'char')
              self.name=name;
          else
              error('the name must be a char')
          end
          if strcmp(class(func),'sym')
              self.func=func;
          elseif strcmp(class(func),'char')
              self.func=sym(func);
          else
              error('function must be either type "sym" or "char"')
          end
          self.funcError=calcError(self.func);
      end
      %Constructs a function instance and calculates and store function error
      function disp(self)
          errChar=regexprep(char(self.funcError),'z_','\\Delta_');
          errLatex=regexprep(latex(self.funcError),'z_','\\Delta_');% a small fix to make "z_" error character to"\delta_"
          fprintf('$function "%s":\nfunction(char):\n%s\nfunction(latex):\n%s\nfunction error(char):\n%s\nfunction error(latex):\n%s\n',self.name,char(self.func),latex(self.func),errChar,errLatex);
      end
      function [resultFunc resultFuncError]=calc(self,dataList,dataErrorList)
          variables=symvar(self.func);
          if numel(dataList)~=numel(variables)
              error(['number of input parameters must be - ' num2str(numel(variables))]);
          end
          if nargin<3
              for i=1:numel(variables)
                  dataErrorList{i}=0;
              end
          else
              if numel(dataErrorList)<numel(variables)
                  error(['number of input error parameters must be - ' num2str(numel(variables))]);
              end
          end
          fun=char(self.func);
          fun=strrep(fun,'*','.*');
          fun=strrep(fun,'^','.^');
          fun=strrep(fun,'/','./');
          funError=char(self.funcError);
          funError=strrep(funError,'*','.*');
          funError=strrep(funError,'^','.^');
          funError=strrep(funError,'/','./');
          for i=1:numel(dataList)
            var=char(variables(i));
            fun=regexprep(fun,['\<' var '\>'],['dataList{' num2str(i) '}']);
            funError=regexprep(funError,['\<' var '\>'],['dataList{' num2str(i) '}']);
            funError=regexprep(funError,['\<' 'z_' var '\>'],['dataErrorList{' num2str(i) '}']);
          end
          resultFunc=eval(fun);
          resultFuncError=eval(funError);
          %replace function variables with "dimentioned" data and then
          %evaluate string as if it was a command line
          %eval(regexprep(char(self.funcError),['\<' char(symvar(self.funcError)) '\>'],num2str(dataList))

      end
          
  end
end  