
classdef Vector
    %   This class implements a field of a one coloumn vector.
    %<a href="matlab:help Vector.Vector ">Vector</a>
    %<a href="matlab:help Vector.getName ">getName</a>
    %<a href="matlab:help Vector.get ">get</a>
    %<a href="matlab:help Vector.getError ">getError</a>
    %<a href="matlab:help Vector.getNum ">getNum</a>
    %<a href="matlab:help Vector.getErrorNum ">getErrorNum</a>
    %<a href="matlab:help Vector.getUnit ">getUnit</a>
    properties(SetAccess=private)
        name  % the name of the vector
        unit  % the unit of the vector 
        data % the vector data
        dataError %the vector of the error
    end
    % This are the properties of the object
    methods (Static) 
        function singleton = getUnitsStruct
        %this static method hold the "units" object for all object of class
        %Vector
             persistent unitStruct;
             if isempty(unitStruct)
                unitStruct = units;
             end
             singleton = unitStruct;
        end
    end

    methods
        function self=Vector(name,unit,data,dataError)
        %function Vector:
        %this method constructs the Vector's instances by recieving field
        %name, unit, data, and data Error. name is saved as it is, while
        %data,error, and unit are changed to "Dimention Variable" type
        %which a type that considers the unit when computing.
        %syntax - Vector(name,unit,data,dataError(optional))
            if nargin==3
                dataError=zeros(numel(data),1);
            end
            if ~strcmp(class(name),'char')
                error('name must be a char type,reminder: arguments must be (name,unit,data,error)')
            elseif ~strcmp(class(unit),'char')
                error('unit must be a char type,reminder: arguments must be (name,unit,data,error)')
            elseif ~strcmp(class(data),'double')
                error('data must be a double type,reminder: arguments must be (name,unit,data,error)')
            elseif ~strcmp(class(dataError),'double')
                error('error must be a double type,reminder: arguments must be (name,unit,data,error)')
            end
            if ~iscolumn(dataError)
                dataError=dataError';
            end
            if ~iscolumn(data)
                data=data';
            end
            if numel(unit)>0  
                unitsStruct=self.getUnitsStruct;
                availableUnits=fieldnames(unitsStruct);
                [matchStart matches] = regexp(unit, '[A-Za-z]*','start','match');
                matchIndex=getnameidx(availableUnits,matches);
                if any(matchIndex==0)
                    unmatchedUnitsIndexes=find(matchIndex==0);
                    firstUnmatched=matches{unmatchedUnitsIndexes(1)};
                    error(['error, unit is not recognizable: "' firstUnmatched '"']);
                end
                if numel(matchStart)==1&&matchStart(1)==1
                        st=['unitsStruct.' unit];
                else
                    if matchStart(1)==1
                            st=['unitsStruct.' unit(1:(matchStart(2)-1))];
                    else
                        st=unit(1:(matchStart(1)-1));
                    end
                    for i=2:(numel(matchStart)-1)
                        st=[st 'unitsStruct.' unit(matchStart(i):(matchStart(i+1)-1))];
                    end
                     st=[st 'unitsStruct.' unit(matchStart(numel(matchStart)):numel(unit))];
                end
                unitVal=eval(st);
            else
                unitVal=1;
            end
            self.unit=unitVal;
            self.data=data*unitVal;
            self.data;
            self.dataError=dataError*unitVal;
            self.name=name;
        end
        function name=getName(self)
        %function getName:
        %returns the name of the Vector
            name=self.name;
        end
        function [data dataError]=get(self)
        %function get:
        %returns data and error in dimentsioned type
        %to get data alone type "data=Vector.get"
        %to get both data and error type "[data dataError]=Vector.get"
            data=self.data;
            dataError=self.dataError;
        end
        function err=getError(self)
        %function getError:
        %returns  error in dimentsioned type
        %to get the eror type "data=Vector.get"
            err=self.dataError;
        end
        function num=getNum(self)
        %function getNum:
        %returns data in double type, this value is measured in the units
        %of the Vector.
            if isa(self.data, 'double')
                num=self.data;
            else
                num=u2num(self.data);
            end
        end
        function errorNum=getErrorNum(self)
        %function getErrorNum:
        %returns data error in double type, this value is measured in the units
        %of the Vector.
            if isa(self.dataError, 'double')
                errorNum=self.dataError;
            else
                errorNum=u2num(self.dataError);
            end
        end 
        function uni=getUnit(self)
        %function getUnit:
        %returns the unit as a string
            if strcmp(class(self.data),'DimensionedVariable')
                [crap un]=unitsOf(self.data);
                un=un(2:numel(un)-1);
                uni=char(sym(regexprep(un,'][','*')));
            elseif strcmp(class(self.data),'double')
                uni='';
            end   
        end 

    end   
end

