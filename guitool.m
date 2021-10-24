function varargout = guitool(varargin)
% GUI for the Option Replication and Portfolio Insurance Toolbox
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guitool_OpeningFcn, ...
                   'gui_OutputFcn',  @guitool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function guitool_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


function varargout = guitool_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% radiobotton Callbacks
function radiobutton2_Callback(hObject, eventdata, handles)
set(handles.popupmenu4, 'visible', 'off');
set(handles.uibuttongroup3, 'visible', 'off');
set(handles.uibuttongroup4, 'visible', 'on');
set(handles.edit1, 'string', '');
set(handles.edit2, 'string', '');
set(handles.edit3, 'string', '');
set(handles.edit4, 'string', '');
set(handles.edit5, 'string', '');
set(handles.edit7, 'string', '');
set(handles.edit5, 'visible', 'off');
set(handles.edit7, 'visible', 'off');
set(handles.text18, 'visible', 'on');
set(handles.text20, 'visible', 'off');
set(handles.text21, 'visible', 'off');
set(handles.text22, 'visible', 'off');
set(handles.text23, 'visible', 'off');
set(handles.text24, 'visible', 'off');
set(handles.text8, 'string', ': Marketed space (X matrix nxm)');
set(handles.text9, 'string', ': Portfolio (theta vector mx1)');
set(handles.text10, 'string', ': Floor (k a real number)');
set(handles.text11, 'string', ': Price (p vector mx1)');
set(handles.checkbox2, 'value', 0);
set(handles.checkbox3, 'value', 0);
set(handles.checkbox4, 'value', 0);
if get(handles.radiobutton20, 'Value')==1
    radiobutton20_Callback(handles.radiobutton20, eventdata, handles);
elseif get(handles.radiobutton21, 'Value')==1
    radiobutton21_Callback(handles.radiobutton21, eventdata, handles);
else
    radiobutton22_Callback(handles.radiobutton22, eventdata, handles);
end


function radiobutton20_Callback(hObject, eventdata, handles)
set(handles.popupmenu1, 'visible', 'on');
set(handles.popupmenu5, 'visible', 'off');
set(handles.popupmenu6, 'visible', 'off');
popupmenu1_Callback(handles.popupmenu1, eventdata, handles);


function radiobutton21_Callback(hObject, eventdata, handles)
set(handles.popupmenu1, 'visible', 'off');
set(handles.popupmenu5, 'visible', 'off');
set(handles.popupmenu6, 'visible', 'on');
popupmenu6_Callback(handles.popupmenu6, eventdata, handles);


function radiobutton22_Callback(hObject, eventdata, handles)
set(handles.popupmenu1, 'visible', 'off');
set(handles.popupmenu5, 'visible', 'on');
set(handles.popupmenu6, 'visible', 'off');
popupmenu5_Callback(handles.popupmenu5, eventdata, handles);


function radiobutton3_Callback(hObject, eventdata, handles)
set(handles.popupmenu4, 'visible', 'on');
set(handles.popupmenu1, 'visible', 'off');
set(handles.popupmenu5, 'visible', 'off');
set(handles.popupmenu6, 'visible', 'off');
set(handles.edit4, 'visible', 'on');
set(handles.text11, 'visible', 'off');
set(handles.text18, 'visible', 'off');
set(handles.text19, 'visible', 'on');
set(handles.text19, 'string', 'in terms of variable t (time).');
set(handles.edit1, 'string', '');
set(handles.edit2, 'string', '');
set(handles.edit3, 'string', '');
set(handles.edit4, 'string', '');
set(handles.text8, 'string', ': Marketed space (X vector mx1)');
set(handles.edit2, 'visible', 'off');
set(handles.edit5, 'visible', 'on');
set(handles.edit7, 'visible', 'on');
set(handles.text22, 'visible', 'on');
set(handles.text23, 'visible', 'on');
set(handles.text24, 'visible', 'on');
set(handles.text9, 'visible', 'on');
set(handles.text9, 'string', ': Time range [a,b]');
set(handles.edit3, 'visible', 'on');
set(handles.text10, 'visible', 'on');
set(handles.text20, 'visible', 'on');
set(handles.text21, 'visible', 'on');
set(handles.uibuttongroup4, 'visible', 'off');
set(handles.checkbox3, 'visible', 'off');
set(handles.checkbox4, 'visible', 'off');
set(handles.checkbox2, 'value', 0);
popupmenu4_Callback(handles.popupmenu4, eventdata, handles);


function radiobutton6_Callback(hObject, eventdata, handles)
set(handles.edit5, 'enable', 'on');
set(handles.edit7, 'enable', 'off');
set(handles.edit7, 'string', '');


function radiobutton7_Callback(hObject, eventdata, handles)
set(handles.edit5, 'enable', 'off');
set(handles.edit7, 'enable', 'on');
set(handles.edit5, 'string', '');

% popupmenu Callbacks
function popupmenu1_Callback(hObject, eventdata, handles)
contents = get(handles.popupmenu1,'String'); 
popupmenuvalue = contents{get(handles.popupmenu1,'Value')};
switch popupmenuvalue
    case 'SUBlat'
        set(handles.edit2, 'visible', 'off');
        set(handles.text9, 'visible', 'off');
        set(handles.edit3, 'visible', 'off');
        set(handles.text10, 'visible', 'off');
        set(handles.edit4, 'visible', 'off');
        set(handles.text11, 'visible', 'off');
        set(handles.text19, 'visible', 'off');
        set(handles.text17, 'string', 'Sublattice');
        set(handles.text18, 'string', 'Positive basis');
        set(handles.checkbox3, 'visible', 'on');
        set(handles.checkbox4, 'visible', 'off');
    case 'SUBlatSUB'
        set(handles.edit2, 'visible', 'off');
        set(handles.text9, 'visible', 'off');
        set(handles.edit3, 'visible', 'off');
        set(handles.text10, 'visible', 'off');
        set(handles.edit4, 'visible', 'off');
        set(handles.text11, 'visible', 'off');
        set(handles.text19, 'visible', 'off');
        set(handles.text17, 'string', 'Positive basis');
        set(handles.text18, 'string', 'Dimensions');
        set(handles.checkbox3, 'visible', 'on');
        set(handles.checkbox4, 'visible', 'off');
    case 'MINlat'
        set(handles.edit2, 'visible', 'off');
        set(handles.text9, 'visible', 'off');
        set(handles.edit3, 'visible', 'off');
        set(handles.text10, 'visible', 'off');
        set(handles.edit4, 'visible', 'off');
        set(handles.text11, 'visible', 'off');
        set(handles.text19, 'visible', 'off');
        set(handles.text17, 'string', 'MLS = Minimal Lattice-Subspace');
        set(handles.text18, 'string', 'Positive basis');
        set(handles.checkbox3, 'visible', 'on');
        set(handles.checkbox4, 'visible', 'off');
end


function popupmenu4_Callback(hObject, eventdata, handles)
contents = get(handles.popupmenu4,'String'); 
popupmenuvalue = contents{get(handles.popupmenu4,'Value')};
switch popupmenuvalue
    case 'minsport'
        set(handles.edit5, 'enable', 'on');
        set(handles.edit7, 'enable', 'on');
        set(handles.uibuttongroup3, 'visible', 'off');
        set(handles.edit3, 'visible', 'on');
        set(handles.text10, 'string', ': Portfolio (theta vector mx1)');
        set(handles.text11, 'string', ': Floor (phi vector mx1)');
        set(handles.edit4, 'visible', 'on');
        set(handles.text11, 'visible', 'on');
        set(handles.text17, 'string', 'mip = minimum-cost insured portfolio at every arbitrage price');
    case 'rabopb'
        set(handles.uibuttongroup3, 'visible', 'on');
        set(handles.edit3, 'visible', 'off');
        set(handles.text10, 'string', ': Choose a or b to find the range of the other');
        set(handles.edit4, 'visible', 'off');
        set(handles.text11, 'visible', 'off');
        set(handles.text17, 'string', 'bb = the range of a or b, it depends on your selection above');
        if get(handles.radiobutton6, 'value')==1
            set(handles.edit5, 'enable', 'on');
            set(handles.edit7, 'enable', 'off');
            set(handles.edit7, 'string', '');
        else
            set(handles.edit5, 'enable', 'off');
            set(handles.edit7, 'enable', 'on');
            set(handles.edit5, 'string', '');
        end
end


function popupmenu5_Callback(hObject, eventdata, handles)
contents = get(handles.popupmenu5,'String'); 
popupmenuvalue = contents{get(handles.popupmenu5,'Value')};
switch popupmenuvalue
    case 'mpiportfolio'
        set(handles.edit2, 'visible', 'on');
        set(handles.text9, 'visible', 'on');
        set(handles.edit3, 'visible', 'on');
        set(handles.text10, 'visible', 'on');
        set(handles.edit4, 'visible', 'on');
        set(handles.text11, 'visible', 'on');
        set(handles.text19, 'visible', 'on');
        set(handles.text17, 'string', 'mpiportfolio = minimum-premium insurance portfolio');
        set(handles.text18, 'string', 'Insured payoff');
        set(handles.text19, 'string', 'Minimum value of the problem');
        set(handles.checkbox3, 'visible', 'on');
        set(handles.checkbox4, 'visible', 'on');
    case 'mcpinsurance'
        set(handles.edit2, 'visible', 'on');
        set(handles.text9, 'visible', 'on');
        set(handles.edit3, 'visible', 'on');
        set(handles.text10, 'visible', 'on');
        set(handles.edit4, 'visible', 'off');
        set(handles.text11, 'visible', 'off');
        set(handles.text19, 'visible', 'off');
        set(handles.text17, 'string', 'theta_k = minimum-cost insured portfolio');
        set(handles.text18, 'string', '');
        set(handles.checkbox3, 'visible', 'off');
        set(handles.checkbox4, 'visible', 'off');
end


function popupmenu6_Callback(hObject, eventdata, handles)
contents = get(handles.popupmenu6,'String'); 
popupmenuvalue = contents{get(handles.popupmenu6,'Value')};
switch popupmenuvalue
    case 'srtest'
        set(handles.edit2, 'visible', 'off');
        set(handles.text9, 'visible', 'off');
        set(handles.edit3, 'visible', 'off');
        set(handles.text10, 'visible', 'off');
        set(handles.edit4, 'visible', 'off');
        set(handles.text11, 'visible', 'off');
        set(handles.text19, 'visible', 'off');
        set(handles.text17, 'string', 'Pb_Completion = positive basis of a partition of the unit');
        set(handles.text18, 'string', 'Pb_Minimal_ls = positive basis of a minimal lattice-subspace');
        set(handles.checkbox3, 'visible', 'on');
        set(handles.checkbox4, 'visible', 'off');
    case 'reprices'
        set(handles.edit2, 'visible', 'on');
        set(handles.text9, 'visible', 'on');
        set(handles.edit3, 'visible', 'off');
        set(handles.text10, 'visible', 'off');
        set(handles.edit4, 'visible', 'off');
        set(handles.text11, 'visible', 'off');
        set(handles.text19, 'visible', 'off');
        set(handles.text17, 'string', 'Reprices = cell array containing the replicated exercise prices');
        set(handles.text18, 'string', 'Npb = positive basis');
        set(handles.checkbox3, 'visible', 'on');
        set(handles.checkbox4, 'visible', 'off');
    case 'mrsubspace'
        set(handles.edit2, 'visible', 'off');
        set(handles.text9, 'visible', 'off');
        set(handles.edit3, 'visible', 'off');
        set(handles.text10, 'visible', 'off');
        set(handles.edit4, 'visible', 'off');
        set(handles.text11, 'visible', 'off');
        set(handles.text19, 'visible', 'off');
        set(handles.text17, 'string', 'Npb = positive basis');
        set(handles.text18, 'string', 'Cprb = corresponding projection basis');
        set(handles.checkbox3, 'visible', 'on');
        set(handles.checkbox4, 'visible', 'off');
end

% pushbutton Callbacks
function pushbutton_Callback(hObject, eventdata, handles)
if get(handles.radiobutton2, 'Value')==1
if get(handles.radiobutton20, 'Value')==1
contents = get(handles.popupmenu1,'String'); 
popupmenuvalue = contents{get(handles.popupmenu1,'Value')};
if isempty(get(handles.edit1,'String'))
    fprintf('ERROR: not enough input arguments\n')
    return
end
A = evalin('base', get(handles.edit1,'String'));
[M,N] = size(A);
switch popupmenuvalue
    case 'SUBlat'
        [Sublattice, Positivebasis] = SUBlat(A);
        assignin('base', 'Sublattice', Sublattice)
        assignin('base', 'Positivebasis', Positivebasis)
        if get(handles.checkbox2, 'Value')==1
            openvar('Sublattice')
        end
        if get(handles.checkbox3, 'Value')==1
            openvar('Positivebasis')
        end
    case 'SUBlatSUB'
        [positivebasis,dimensions] = SUBlatSUB(A);
        assignin('base', 'positivebasis', positivebasis)
        assignin('base', 'dimensions', dimensions)
        if get(handles.checkbox2, 'Value')==1
            openvar('positivebasis')
        end
        if get(handles.checkbox3, 'Value')==1
            openvar('dimensions')
        end
    case 'MINlat'
        [MLS, Positivebasis] = MINlat(A);
        assignin('base', 'MLS', MLS)
        assignin('base', 'Positivebasis', Positivebasis)
        if get(handles.checkbox2, 'Value')==1
            openvar('MLS')
        end
        if get(handles.checkbox3, 'Value')==1
            openvar('Positivebasis')
        end
end
elseif get(handles.radiobutton22, 'Value')==1
contents = get(handles.popupmenu5,'String'); 
popupmenuvalue = contents{get(handles.popupmenu5,'Value')};
if isempty(get(handles.edit1,'String'))
    fprintf('ERROR: not enough input arguments\n')
    return
end
A = evalin('base', get(handles.edit1,'String'));
[M,N] = size(A);   
switch popupmenuvalue
    case 'mpiportfolio'
        if isempty(get(handles.edit2,'String'))||isempty(get(handles.edit3,'String'))...
                ||isempty(get(handles.edit4,'String'))
            fprintf('ERROR: not enough input arguments\n')
        else
        theta = evalin('base', get(handles.edit2,'String'));
        [x,y] = size(theta);
        if x==1 && y==N
            theta = theta';
        elseif x==1 && y~=N
            fprintf('ERROR: portfolio (theta) must be mx1\n')
            return
        elseif y==1 && x~=N
            fprintf('ERROR: portfolio (theta) must be mx1\n')
            return
        elseif y~=1 && x~=1
            fprintf('ERROR: portfolio (theta) must be mx1\n')
            return
        end
        floor = evalin('base', get(handles.edit3,'String'));
        [x,y] = size(floor);
        if x~=1 || y~=1
            fprintf('ERROR: floor must be a real number\n')
            return
        end
        price = evalin('base', get(handles.edit4,'String'));
        [x,y] = size(price);
        if x==1 && y==N
            price = price';
        elseif x==1 && y~=N
            fprintf('ERROR: price (p) must be mx1\n')
            return
        elseif y==1 && x~=N
            fprintf('ERROR: price (p) must be mx1\n')
            return
        elseif y~=1 && x~=1
            fprintf('ERROR: price (p) must be mx1\n')
            return
        end
        [insuredpayoff, mpiportfol, minvalue] = mpiportfolio(A,theta,floor,price);
        assignin('base', 'insuredpayoff', insuredpayoff)
        assignin('base', 'mpiportfol', mpiportfol)
        assignin('base', 'minvalue', minvalue)
        if get(handles.checkbox2, 'Value')==1
            openvar('insuredpayoff')
        end
        if get(handles.checkbox3, 'Value')==1
            openvar('mpiportfol')
        end
        if get(handles.checkbox4, 'Value')==1
            openvar('minvalue')
        end
        end
    case 'mcpinsurance'
        if isempty(get(handles.edit2,'String'))||isempty(get(handles.edit3,'String'))
            fprintf('ERROR: not enough input arguments\n')
        else
        floorvector = evalin('base', get(handles.edit3,'String'));
        [x,y] = size(floorvector);
        if x~=1 || y~=1
            fprintf('ERROR: floor must be a real number\n')
            return
        end
        portfolio = evalin('base', get(handles.edit2,'String'));
        [x,y] = size(portfolio);
        if x==1 && y==N
            portfolio = portfolio';
        elseif x==1 && y~=N
            fprintf('ERROR: portfolio (theta) must be mx1\n')
            return
        elseif y==1 && x~=N
            fprintf('ERROR: portfolio (theta) must be mx1\n')
            return
        elseif y~=1 && x~=1
            fprintf('ERROR: portfolio (theta) must be mx1\n')
            return
        end
        floorvector = floorvector*ones(1,M);
        [theta_k]=mcpinsurance(A,floorvector,portfolio);
        if isempty(theta_k)
            return
        end
        assignin('base', 'theta_k', theta_k)
        if get(handles.checkbox2, 'Value')==1
            openvar('theta_k')
        end
        end
end
else
contents = get(handles.popupmenu6,'String'); 
popupmenuvalue = contents{get(handles.popupmenu6,'Value')};
if isempty(get(handles.edit1,'String'))
    fprintf('ERROR: not enough input arguments\n')
    return
end
A = evalin('base', get(handles.edit1,'String'));
[M,N] = size(A); 
switch popupmenuvalue
    case 'srtest'
        warning('off','all');
        [Pb_Completion,Pb_Minimal_ls] = srtest(A);
        if isempty(Pb_Completion) && isempty(Pb_Minimal_ls)
            return
        end
        assignin('base', 'Pb_Completion', Pb_Completion)
        assignin('base', 'Pb_Minimal_ls', Pb_Minimal_ls)
        if get(handles.checkbox2, 'Value')==1
            openvar('Pb_Completion')
        end
        if get(handles.checkbox3, 'Value')==1
            openvar('Pb_Minimal_ls')
        end
    case 'reprices'
        if isempty(get(handles.edit2,'String'))
            fprintf('ERROR: not enough input arguments\n')
        else
        B = evalin('base', get(handles.edit2,'String'));
        [x,y] = size(B);
        if x==1 && y==M
            B = B';
        elseif x==1 && y~=M
            fprintf('ERROR: portfolio (theta) must be mx1\n')
            return
        elseif y==1 && x~=M
            fprintf('ERROR: portfolio (theta) must be mx1\n')
            return
        elseif y~=1 && x~=1
            fprintf('ERROR: portfolio (theta) must be mx1\n')
            return
        end
        [Reprices,Npb] = reprices(A,B);
        assignin('base', 'Reprices', Reprices)
        assignin('base', 'Npb', Npb)
        if get(handles.checkbox2, 'Value')==1
            openvar('Reprices')
        end
        if get(handles.checkbox3, 'Value')==1
            openvar('Npb')
        end
        end
    case 'mrsubspace'
        [Npb,Cprb] = mrsubspace(A);
        if isempty(Npb) && isempty(Cprb)
            return
        end
        assignin('base', 'Npb', Npb)
        assignin('base', 'Cprb', Cprb)
        if get(handles.checkbox2, 'Value')==1
            openvar('Npb')
        end
        if get(handles.checkbox3, 'Value')==1
            openvar('Cprb')
        end
end
end
else
sym='syms t';
evalin('base',sym);
contents = get(handles.popupmenu4,'String'); 
popupmenuvalue = contents{get(handles.popupmenu4,'Value')};
switch popupmenuvalue
    case 'minsport'
if isempty(get(handles.edit1,'String'))||isempty(get(handles.edit3,'String'))...
                ||isempty(get(handles.edit4,'String'))||isempty(get(handles.edit5,'String'))...
                ||isempty(get(handles.edit7,'String'))
            fprintf('ERROR: not enough input arguments\n')
else    
    K = evalin('base', get(handles.edit1,'String'));
    a = evalin('base', get(handles.edit5,'String'));
    b = evalin('base', get(handles.edit7,'String'));
    theta = evalin('base', get(handles.edit3,'String'));
    phi = evalin('base', get(handles.edit4,'String'));
    if size(K,1)==1
        fprintf('ERROR: Marketed space (X) must be mx1\n')
        return
    end
    if a>=b
        fprintf('ERROR: a must be < b\n')
        return
    end
    [x,y] = size(theta);
    if x==size(K,1) && y==1
        theta=theta';
    elseif x~=1 || y~=size(K,1)
        fprintf('ERROR: Portfolio (theta) must be mx1\n')
        return
    end
    [x,y] = size(phi);
    if x==size(K,1) && y==1
        phi=phi';
    elseif x~=1 || y~=size(K,1)
        fprintf('ERROR: Floor (phi) must be mx1\n')
        return
    end
    [pb,mip]=minsport(K,a,b,theta,phi);
        if isempty(pb)
            fprintf('The positive basis does not exist, hence the minimum cost insured portfolio can not be calculated\n')
            return
        end
        if ~isempty(mip)
            assignin('base', 'mip', mip)
            mip
            if get(handles.checkbox2, 'Value')==1
                openvar('mip')
            end
        elseif isempty(mip) && ~isempty(pb)
            fprintf('The values of theta or phi are not suitable for the calculation of the minimum cost insured portfolio\n')
        end
end
    case 'rabopb'
        if isempty(get(handles.edit1,'String'))
            fprintf('ERROR: not enough input arguments\n')
            return
        end
        if get(handles.radiobutton6, 'value')==1 && isempty(get(handles.edit5,'String'))
            fprintf('ERROR: not enough input arguments\n')
            return
        elseif get(handles.radiobutton7, 'value')==1 && isempty(get(handles.edit7,'String'))
            fprintf('ERROR: not enough input arguments\n')
            return
        end
        K = evalin('base', get(handles.edit1,'String'));
        if size(K,1)==1
            fprintf('ERROR: Marketed space (X) must be mx1\n')
            return
        end
        if get(handles.radiobutton6, 'value')==1
        x1 = evalin('base', get(handles.edit5,'String'));
        ab=0;
        else
        x1 = evalin('base', get(handles.edit7,'String'));
        ab=1;
        end
        bb=rabopb(K,x1,ab);
        if ~isempty(bb)
            assignin('base', 'bb', double(bb))
            bb
            if get(handles.checkbox2, 'Value')==1
                openvar('bb')
            end
        else
            fprintf('The Marketed space does not have positive basis for any a or b.\n')
        end        
end    
end


function pushbutton2_Callback(hObject, eventdata, handles)
open help.pdf
