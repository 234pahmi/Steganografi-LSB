function varargout = stegano_LSB(varargin)
% STEGANO_LSB MATLAB code for stegano_LSB.fig
%      STEGANO_LSB, by itself, creates a new STEGANO_LSB or raises the existing
%      singleton*.
%
%      H = STEGANO_LSB returns the handle to a new STEGANO_LSB or the handle to
%      the existing singleton*.
%
%      STEGANO_LSB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEGANO_LSB.M with the given input arguments.
%
%      STEGANO_LSB('Property','Value',...) creates a new STEGANO_LSB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stegano_LSB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stegano_LSB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text5 to modify the response to help stegano_LSB

% Last Modified by GUIDE v2.5 20-Dec-2017 11:20:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stegano_LSB_OpeningFcn, ...
                   'gui_OutputFcn',  @stegano_LSB_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before stegano_LSB is made visible.
function stegano_LSB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stegano_LSB (see VARARGIN)

% Choose default command line output for stegano_LSB
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stegano_LSB wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stegano_LSB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function txtPesanDekripsi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPesanDekripsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function txtPesanEktraksi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPesanEktraksi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in btnEktraksi.
function btnEktraksi_Callback(hObject, eventdata, handles)
% hObject    handle to btnEktraksi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = getappdata(0,'nInFunction');
priv_key = getappdata(0,'pkInFunction');
e = getappdata(0,'eInFunction');
pjg_bit_pesan = getappdata(0,'pjgInFunction');
hasil_gmb_stego = getappdata(0,'hslInFunction');

%ekstraksi LSB
[pesan_ektraksi]=ekstraksilsb(hasil_gmb_stego,pjg_bit_pesan);
set(handles.txtPesanEktraksi,'string',pesan_ektraksi);

%decrypt RSA
decr=decryptrsa(pesan_ektraksi,N,priv_key,e);
set(handles.txtPesanDekripsi,'string',decr);




% --- Executes on button press in btnPenyisipan.
function btnPenyisipan_Callback(hObject, eventdata, handles)
% hObject    handle to btnPenyisipan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pesan=get(handles.txtPesanAsli,'string');

%encrypt RSA
[chip,PK,N,e,enc]=encryptrsa(pesan);
set(handles.txtPesanEnkripsi,'string',enc);

%penyisipan LSB
gmb_asli=getimage(handles.axesGambarAsli);
[pjg_bit_pesan,hasil_gmb_stego]=lsbsisipcolor(enc,gmb_asli);
axes(handles.axesGambarStego);
imshow(hasil_gmb_stego); 
handles.gmb_hasil = hasil_gmb_stego;
guidata(hObject,handles);






% --- Executes during object creation, after setting all properties.
function txtPesanAsli_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPesanAsli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function txtPesanEnkripsi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPesanEnkripsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in btnPilihGambar.
function btnPilihGambar_Callback(hObject, eventdata, handles)
% hObject    handle to btnPilihGambar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName]=uigetfile('*.bmp;*.jpg','Select Image file');
global fullpathname1
fullpathname1 = strcat(PathName,FileName); %Resmin ismini ve konumunu birleþtirdik.
set(handles.txtPilihGambar,'String',fullpathname1);
gmb_asli = imread(fullpathname1);
handles.gmb_asli=gmb_asli; % menyimpan nilai variabel
guidata(hObject,handles);% instruksi simpan object

axes(handles.axesGambarAsli); % memasukkan nilai variabel pada axis
imshow(gmb_asli); % menampilkan image hasil browse




% --- Executes on button press in btnPilihFilePesan.
function btnPilihFilePesan_Callback(hObject, eventdata, handles)
% hObject    handle to btnPilihFilePesan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename2 pathname2]=uigetfile({'*.txt'},'File Selector'); %Dosya sisteminden .txt uzantýlý dosya seçilir.
global fullpathname2
fullpathname2 = strcat(pathname2,filename2); %Dosyanýn ismini ve konumunu birleþtirdik.
set(handles.txtPilihFilePesan,'String',fullpathname2); %Dosyanýn ismini ve konumunu textbox a yazdýrdýk.
pesan = fileread(fullpathname2); %Dosyayý Okuduk.
if length(pesan) > 300
    pesan=pesan(1:300);
end
set(handles.txtPesanAsli,'String',pesan); %Dosya içeriðini Textbox'a yazdýrdýk.




% --- Executes during object creation, after setting all properties.
function txtPilihGambar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPilihGambar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function txtPilihFilePesan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPilihFilePesan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in btnReset.
function btnReset_Callback(hObject, eventdata, handles)
% hObject    handle to btnReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txtPilihGambar,'String','');
set(handles.txtPilihFilePesan,'String','');
set(handles.txtPesanAsli,'String','');
set(handles.txtPesanEnkripsi,'String','');
set(handles.txtPesanEktraksi,'String','');
set(handles.txtPesanDekripsi,'String','');
set(handles.txtEkstraksiStego,'String','');
set(handles.txtDeksripsiStego,'String','');
axes(handles.axesStego); cla;
axes(handles.axesGambarAsli); cla;
axes(handles.axesGambarStego); cla;



% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gmb_hasil = handles.gmb_hasil;
[nama_file_save,path_save] = uiputfile(...
    {'*.bmp','File Bitmap(*.bmp)';...
     '*.jpg','File jpeg(*.jpg)';
     '*.*','All Files(*.*)'},...
     'Save Image');
 
 if ~isequal(nama_file_save,0)
     imwrite(gmb_hasil, fullfile(path_save,nama_file_save));
 else
     return
 end


% --- Executes on button press in btnEkstraksiPesanStego.
function btnEkstraksiPesanStego_Callback(hObject, eventdata, handles)
% hObject    handle to btnEkstraksiPesanStego (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = getappdata(0,'nInFunction');
priv_key = getappdata(0,'pkInFunction');
e = getappdata(0,'eInFunction');
pjg_bit_pesan = getappdata(0,'pjgInFunction');
gmb_asli_stego = getappdata(0,'hslInFunction');

%ekstraksi LSB
[pesan_ektraksi]=ekstraksilsb(gmb_asli_stego,pjg_bit_pesan);
set(handles.txtEkstraksiStego,'string',pesan_ektraksi);

%decrypt RSA
decr=decryptrsa(pesan_ektraksi,N,priv_key,e);
set(handles.txtDeksripsiStego,'string',decr);




% --- Executes on button press in btnPilihGambarStego.
function btnPilihGambarStego_Callback(hObject, eventdata, handles)
% hObject    handle to btnPilihGambarStego (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName]=uigetfile('*.bmp;*.jpg','Select Image file');
global fullpathname1
fullpathname1 = strcat(PathName,FileName); %Resmin ismini ve konumunu birleþtirdik.
gmb_asli_stego = imread(fullpathname1);
handles.gmb_asli=gmb_asli_stego; % menyimpan nilai variabel
guidata(hObject,handles);% instruksi simpan object

axes(handles.axesStego); % memasukkan nilai variabel pada axis
imshow(gmb_asli_stego); % menampilkan image hasil browse
