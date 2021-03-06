unit UnitLogin;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Actions,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Objects,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.ActnList;

type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConta: TTabItem;
    StyleBook1: TStyleBook;
    Image1: TImage;
    lbl_criar: TLabel;
    Layout1: TLayout;
    Image2: TImage;
    Rectangle1: TRectangle;
    edt_email: TEdit;
    Rectangle2: TRectangle;
    edt_senha: TEdit;
    btn_nova_conta: TSpeedButton;
    Image3: TImage;
    lbl_Login: TLabel;
    Layout2: TLayout;
    Image4: TImage;
    Rectangle3: TRectangle;
    edt_cad_nome: TEdit;
    Rectangle4: TRectangle;
    edt_cad_senha: TEdit;
    SpeedButton1: TSpeedButton;
    Rectangle5: TRectangle;
    edt_cad_email: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ActionList1: TActionList;
    ActLogin: TChangeTabAction;
    ActConta: TChangeTabAction;
    procedure FormCreate(Sender: TObject);
    procedure lbl_LoginClick(Sender: TObject);
    procedure lbl_criarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  TabControl.TabPosition := TTabPosition.None;

end;

procedure TFrmLogin.lbl_criarClick(Sender: TObject);
begin
  ActConta.Execute;
end;

procedure TFrmLogin.lbl_LoginClick(Sender: TObject);
begin
  ActLogin.Execute;
end;

end.
