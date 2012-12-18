
classdef Vector
    %   This class implements a field of a one coloumn vector.
    %syntax - Vector(name,unit,data,dataError(optional))
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
                [matchStart matches] = regexp(unit, '[A-Za-z]','start','match');
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
            self.dataError=dataError*unitVal;
            self.name=name;
        end
        
        function name=getName(self)
        %returns the name of the Vector
            name=self.name;
        end
        
        function [data dataError]=get(self)
        %returns data and error in dimentsioned type
        %to get data alone type "data=Vector.get"
        %to get both data and error type "[data dataError]=Vector.get"
            data=self.data;
            dataError=self.dataError;
        end
        function num=getNum(self)
        %returns data in double type, this value is measured in the units
        %of the Vector.
            if isa(self.data, 'double')
                num=self.data
            else
                num=u2num(self.data);
            end
        end
        
        function errorNum=getErrorNum(self)
        %returns data error in double type, this value is measured in the units
        %of the Vector.
            if isa(self.dataError, 'double')
                errorNum=self.dataError
            else
                errorNum=u2num(self.dataError);
            end
        end
        
        
        function uni=getUnit(self)
        %returns the value of the unit as a dimensioned variable
            if strcmp(class(self.data),'DimensionedVariable')
                [crap un]=unitsOf(self.data);
                un=un(units2:numel(un)-1);
                uni=char(sym(regexprep(un,'][','*')));
            elseif strcmp(class(self.data),'double')
                uni='';
            end   
        end          
    end   
end

