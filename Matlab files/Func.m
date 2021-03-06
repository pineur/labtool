classdef Func
  %This class implements a function. upon construction it calculates the
  %error propogation function.
    %<a href="matlab:help Func.Func ">Func</a>
    %<a href="matlab:help Func.calc ">calc</a>
    %<a href="matlab:help Func.getName ">getName</a>
    %<a href="matlab:help Func.getVariables ">getVariables</a>

  properties(SetAccess=private)
      name % The name of the function
      func % The function itself  as a symbolic type
      funcError % The function error itself as a symbolic type

  end

  methods
      function self=Func(name,func)
      %function Func:
      %Constructs a function instance and calculates and store function error
      %syntax: Func(name,func)
      %where func is a symbolic of the function, or a char array and name
      %is the name of the function
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
          fprintf('\nfunction preview:\n')
          pretty(self.func);
          fprintf('\nvariable list in order:\n')
          disp(symvar(self.func));
      end
      
      function disp(self)
          errChar=regexprep(char(self.funcError),'z_','\\Delta_');
          errLatex=regexprep(latex(self.funcError),'z_','\\Delta_');% a small fix to make "z_" error character to"\delta_"
          fprintf('$function "%s":\nfunction(char):\n%s\nfunction(latex):\n%s\nfunction error(char):\n%s\nfunction error(latex):\n%s\n',self.name,char(self.func),latex(self.func),errChar,errLatex);
      end
      function [resultFunc resultFuncError]=calc(self,vectorList)
      %function calc:
      %calculate the function by giving it parameters
      %syntax- [resultFunc resultFuncError]=Func.calc(dataList,dataErrorList(optional))
      %data List is a list of columns or rows, for example dataList={a b c}
      %where a,b,c are either columns or rows.
      %errordataList is the same as dataList, only it is optional whether
      %you wish to calculate error as well.
      %NOTICE - it is very important to keep the input lists syncronous to
      %those of the function, to see the right order use the "getVariables"
      %method
          if nargin<2
              error('not enugh arguments given, syntax is as following: Func.calc(vectorList)');
          end
          if ~isa(vectorList,'Vector')
              error('argument must be an array of Vectors, syntax is as following: Func.calc(vectorList)');
          end
          variables=symvar(self.func);
          if numel(vectorList)~=numel(variables)
              error(['number of input parameters(function input) must be - ' num2str(numel(variables))]);
          end        
          %change the function and the function error operations to
          %"cell to cell" operations
          fun=char(self.func);
          fun=strrep(fun,'*','.*');
          fun=strrep(fun,'^','.^');
          fun=strrep(fun,'/','./');
          funError=char(self.funcError);
          funError=strrep(funError,'*','.*');
          funError=strrep(funError,'^','.^');
          funError=strrep(funError,'/','./');
          for i=1:numel(vectorList)
            var=char(variables(i));
            fun=regexprep(fun,['\<' var '\>'],['vectorList(' num2str(i) ').get']);
            funError=regexprep(funError,['\<' var '\>'],['vectorList(' num2str(i) ').get']);
            funError=regexprep(funError,['\<' 'z_' var '\>'],['vectorList(' num2str(i) ').getError']);
            %replace variable with parameter
          end
          resultFunc=eval(fun);
          resultFuncError=eval(funError);
          %evaluate string as if it was a command
      end
      
      function name=getName(self)
      %function getName
      %returns the name of the function
      %syntax Func.getName
          name=self.name;
      end

      function funcVar=getVariables(self)
      %function  getVariables
      %returns the variables of the function in their right order
      %syntax Func.getVariables
          funcVar=symvar(self.func);
      end
          
  end
end  
