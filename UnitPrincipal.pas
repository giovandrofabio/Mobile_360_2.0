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
  FMX.Layouts, FMX.Objects, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

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
    Line1: TLine;
    toolbar: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    lv_pedido: TListView;
    Rectangle1: TRectangle;
    edt_email: TEdit;
    StyleBook1: TStyleBook;
    Image1: TImage;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Image2: TImage;
    Layout2: TLayout;
    Rectangle3: TRectangle;
    Edit1: TEdit;
    lv_clientes: TListView;
    Rectangle4: TRectangle;
    Label3: TLabel;
    lv_notificacao: TListView;
    Rectangle5: TRectangle;
    Label4: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    img_produtos: TImage;
    Label5: TLabel;
    img_sincronizar: TImage;
    Label6: TLabel;
    Layout5: TLayout;
    img_perfil: TImage;
    Label7: TLabel;
    img_indicar: TImage;
    Label8: TLabel;
    img_sair: TImage;
    Label9: TLabel;
    procedure img_tab_pedidoClick(Sender: TObject);
    procedure SelecionaTab(img: TImage);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddPedido(pedido, cliente, dt_pedido, ind_entregue, status :string;
                        valor : Double);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.AddPedido(pedido, cliente, dt_pedido, ind_entregue,
  status: string; valor: Double);
var
   item : TListViewItem;
   txt: TListItemText;
begin
   try
      item := lv_pedido.Items.Add;

      with item do
      begin
        //Numero do Pedido...
        txt      := TListItemText(Objects.FindDrawable('TxtPedido'));
        txt.Text := 'Pedido #' + pedido;

        //Cliente...
        txt      := TListItemText(Objects.FindDrawable('TxtCliente'));
        txt.Text := cliente;

        //Data do Pedido...
        txt      := TListItemText(Objects.FindDrawable('TxtData'));
        txt.Text := dt_pedido;

        //Valor...
        txt      := TListItemText(Objects.FindDrawable('TxtValor'));
        txt.Text := 'R$' +  FormatFloat('#,##0.00', Valor);

      end;
   except on E: Exception do
      ShowMessage('Erro ao inserir pedido na lista:' + e.Message);
   end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  TabControl.TabPosition := TTabPosition.None;
  TabControl.ActiveTab   := TabPedido;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
   SelecionaTab(img_tab_pedido);

   AddPedido('0001','99 Coders','15/02/2022','S','P',500);
   AddPedido('0002','Walmart','18/02/2022','N','P',9000);
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
