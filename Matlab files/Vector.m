
classdef Vector
    %   This class implements a field of a one coloumn vector.
    properties(SetAccess=private)
        name  % the name of the vector
        unit  % the unit of the vector 
        data % the vector data
        dataError %the vector of the error
    end
    % This are the properties of the object
    methods (Static) 
        function singleton = getUnitsStruct
             persistent unitStruct;
             if isempty(unitStruct)
                unitStruct = units;
             end
             singleton = unitStruct;
        end
    end
    %this static method hold the "units" object for all object of class
    %Vector
    methods
        function self=Vector(name,unit,data,dataError)
            if nargin==3
                dataError=zeros(numel(data));
            end
            if ~strcmp(class(name),'char')
                error('name must be a char type,reminder: arguments must be (name,unit,data,error)')
            elseif ~strcmp(class(unit),'char')
                error('unit must be a char type,reminder: arguments must be (name,unit,data,error)')
            elseif ~strcmp(class(data),'double')
                error('name must be a double type,reminder: arguments must be (name,unit,data,error)')
            elseif ~strcmp(class(dataError),'double')
                error('name must be a double type,reminder: arguments must be (name,unit,data,error)')
            end
            u=self.getUnitsStruct;
            availableUnits=fieldnames(u);
            [matchStart matches] = regexp(unit, '[a-z]+|[A-Z]','start','match');
            matchIndex=getnameidx(availableUnits,matches);
            if any(matchIndex==0)
                unmatchedUnitsIndexes=find(matchIndex==0);
                firstUnmatched=matches{unmatchedUnitsIndexes(1)};
                error(['error, unit is not recognizable: "' firstUnmatched '"']);
            end
            if numel(matchStart)==1&&matchStart(1)==1
                    st=['u.' unit];
            else
                if matchStart(1)==1
                        st=['u.' unit(1:(matchStart(2)-1))];
                else
                    st=unit(1:(matchStart(1)-1));
                end
                for i=1:(numel(matchStart)-1)
                    st=[st 'u.' unit(matchStart(i):(matchStart(i+1)-1))];
                end
                 st=[st 'u.' unit(matchStart(numel(matchStart)):numel(unit))];
            end
            st
            unitVal=eval(st);
            self.unit=unitVal;
            self.data=data*unitVal;
            self.dataError=dataError*unitVal;
            self.name=name;
        end
        %this method constructs the Vector's instances by recieving field
        %name, unit, data, and data Error. name is saved as it is, while
        %data,error, and unit are changed to "Dimention Variable" type
        %which a type that considers the unit when computing.
        function data=get(self)
            data=self.data;
        end
        function num=getNum(self)
            num=self.data/self.unit;
        end
        function name=getName(self)
            name=self.name;
        end
        function uni=getUnit(self)
            [crap un]=unitsOf(self.data);
            un=un(2:numel(un)-1);
            uni=char(sym(regexprep(un,'][','*')));
        end
        function err=getError(self)
            err=self.dataError;
        end
            
    end
    
end

