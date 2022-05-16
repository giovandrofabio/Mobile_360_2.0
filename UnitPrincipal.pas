unit UnitPrincipal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts, FMX.Objects, FMX.TabControl, System.Actions, FMX.ActnList;

type
  TFrmPrincipal = class(TForm)
    lyt_aba: TLayout;
    lyt_aba_pedido: TLayout;
    lyt_aba_cliente: TLayout;
    lyt_aba_notificacao: TLayout;
    lyt_aba_mais: TLayout;
    img_tab_pedido: TImage;
    img_tab_cliente: TImage;
    img_tab_notificacao: TImage;
    img_tab_mais: TImage;
    TabControl: TTabControl;
    Circle1: TCircle;
    TabPedido: TTabItem;
    TabCliente: TTabItem;
    TabNotificacao: TTabItem;
    TabMais: TTabItem;
    ActionList1: TActionList;
    ActPedido: TChangeTabAction;
    ActCliente: TChangeTabAction;
    ActNotificacao: TChangeTabAction;
    ActMais: TChangeTabAction;
    procedure img_tab_pedidoClick(Sender: TObject);
    procedure SelecionaTab(img: TImage);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  TabControl.TabPosition := TTabPosition.None;
  TabControl.ActiveTab   := TabPedido;
end;

procedure TFrmPrincipal.img_tab_pedidoClick(Sender: TObject);
begin
   SelecionaTab(TImage(Sender));
end;

procedure TFrmPrincipal.SelecionaTab(img: TImage);
begin
  img_tab_pedido.Opacity      := 0.4;
  img_tab_cliente.Opacity     := 0.4;
  img_tab_notificacao.Opacity := 0.4;
  img_tab_mais.Opacity        := 0.4;

  img.Opacity := 1;

  case img.Tag of
    1: ActPedido.Execute;
    2: ActCliente.Execute;
    3: ActNotificacao.Execute;
    4: ActMais.Execute;
  end;
end;

end.
