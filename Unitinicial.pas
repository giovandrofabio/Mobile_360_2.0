unit Unitinicial;

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
  FMX.TabControl,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  FMX.ActnList;

type
  TFrmInicial = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    Layout_proximo: TLayout;
    Layout2: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Layout3: TLayout;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Layout4: TLayout;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Layout5: TLayout;
    Image4: TImage;
    Label7: TLabel;
    StyleBook1: TStyleBook;
    btn_voltar: TSpeedButton;
    btn_proximo: TSpeedButton;
    ActionList1: TActionList;
    ActTab1: TChangeTabAction;
    ActTab2: TChangeTabAction;
    ActTab3: TChangeTabAction;
    ActTab4: TChangeTabAction;
    Layout_botoes: TLayout;
    btn_login: TSpeedButton;
    btn_nova_conta: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_proximoClick(Sender: TObject);
    procedure NavegacaoAba(cont : integer);
    procedure btn_voltarClick(Sender: TObject);
    procedure btn_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_nova_contaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmInicial: TFrmInicial;

implementation

{$R *.fmx}

uses UnitLogin;

procedure TFrmInicial.NavegacaoAba(cont: integer);
begin
  //Proximo....
  if cont > 0 then
  begin
    case TabControl.TabIndex of
      0 : ActTab2.Execute;
      1 : ActTab3.Execute;
      2 : ActTab4.Execute;
    end;
  end
  else
  //Voltar
  begin
    case TabControl.TabIndex of
      3 : ActTab3.Execute;
      2 : ActTab2.Execute;
      1 : ActTab1.Execute;
    end;
  end;

  btn_voltar.Visible  := true;
  btn_proximo.Visible := true;

  //Tratamento dos bot?es
  if TabControl.TabIndex = 0 then
    btn_voltar.Visible  := false
  else if TabControl.TabIndex = 3 then
  begin
    Layout_botoes.Visible  := true;
    Layout_proximo.Visible := false;
  end;
end;

procedure TFrmInicial.btn_loginClick(Sender: TObject);
begin
  if not Assigned(FrmLogin) then
    Application.CreateForm(TFrmLogin, FrmLogin);

  Application.MainForm := FrmLogin;
  FrmLogin.TabControl.ActiveTab := FrmLogin.TabLogin;
  FrmLogin.Show;
  FrmInicial.Close;
end;

procedure TFrmInicial.btn_nova_contaClick(Sender: TObject);
begin
  if not Assigned(FrmLogin) then
    Application.CreateForm(TFrmLogin, FrmLogin);

  Application.MainForm := FrmLogin;
  FrmLogin.TabControl.ActiveTab := FrmLogin.TabConta;
  FrmLogin.Show;
  FrmInicial.Close;
end;

procedure TFrmInicial.btn_proximoClick(Sender: TObject);
begin
  NavegacaoAba(1);
end;

procedure TFrmInicial.btn_voltarClick(Sender: TObject);
begin
  NavegacaoAba(-1);
end;

procedure TFrmInicial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action     := TCloseAction.caFree;
  FrmInicial := nil;
end;

procedure TFrmInicial.FormCreate(Sender: TObject);
begin
  TabControl.TabPosition := TTabPosition.None;
  TabControl.ActiveTab   := TabItem1;
  Layout_proximo.Visible := True;
  Layout_botoes.Visible  := false;
  NavegacaoAba(-1);
end;

end.
