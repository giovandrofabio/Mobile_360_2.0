unit UnitPrincipal;

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
  FMX.Layouts,
  FMX.Objects,
  FMX.TabControl,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.ActnList,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  FMX.Edit;

type
  TFrmPrincipal = class(TForm)
    lyt_aba: TLayout;
    lyt_aba_pedido: TLayout;
    lyt_aba_cliente: TLayout;
    lyt_aba_mais: TLayout;
    lyt_aba_notificacao: TLayout;
    img_tab_pedido: TImage;
    img_tab_cliente: TImage;
    img_tab_notificacao: TImage;
    img_tab_mais: TImage;
    TabControl: TTabControl;
    Circle1: TCircle;
    TabPedido: TTabItem;
    TabCliente: TTabItem;
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
    edt_busca_pedido: TEdit;
    StyleBook1: TStyleBook;
    Image1: TImage;
    lv_clientes: TListView;
    Layout2: TLayout;
    Rectangle2: TRectangle;
    Edit1: TEdit;
    Rectangle3: TRectangle;
    Label2: TLabel;
    Image2: TImage;
    lv_notificacao: TListView;
    Rectangle5: TRectangle;
    Label3: TLabel;
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
    img_entregue: TImage;
    img_sinc: TImage;
    img_nao_sinc: TImage;
    img_busca_pedido: TImage;
    procedure img_tab_pedidoClick(Sender: TObject);
    procedure SelecionaTab(img : TImage);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddPedido(pedido, cliente, dt_pedido, ind_entregue, ind_sinc : string;
                        valor : double);
    procedure ListarPedido(busca : string; ind_clear : boolean);
    procedure img_busca_pedidoClick(Sender: TObject);
    procedure lv_pedidoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitDM;


procedure TFrmPrincipal.AddPedido(pedido, cliente, dt_pedido, ind_entregue,
  ind_sinc: string; valor: double);
var
    item : TListViewItem;
    txt : TListItemText;
    img : TListItemImage;
begin
    try
        item := lv_pedido.Items.Add;

        with item do
        begin
            // Numero pedido...
            txt := TListItemText(Objects.FindDrawable('TxtPedido'));
            if ind_sinc = 'S' then
                txt.Text := 'Pedido #' + pedido
            else
                txt.Text := 'Or�amento';

            // Cliente...
            txt := TListItemText(Objects.FindDrawable('TxtCliente'));
            txt.Text := cliente;

            // Data pedido...
            txt := TListItemText(Objects.FindDrawable('TxtData'));
            txt.Text := dt_pedido;

            // Valor...
            txt := TListItemText(Objects.FindDrawable('TxtValor'));
            txt.Text := 'R$ ' + FormatFloat('#,##0.00', valor);

            // Entregue...
            img := TListItemImage(Objects.FindDrawable('ImgEntregue'));
            if ind_entregue = 'S' then
                img.Bitmap := img_entregue.Bitmap
            else
                img.Visible := false;

            // Sincronizado...
            img := TListItemImage(Objects.FindDrawable('ImgSinc'));
            if ind_sinc = 'S' then
                img.Bitmap := img_sinc.Bitmap
            else
                img.Bitmap := img_nao_sinc.Bitmap

        end;
    except on ex:exception do
        showmessage('Erro ao inserir pedido na lista: ' + ex.Message);
    end;
end;

procedure TFrmPrincipal.ListarPedido(busca: string; ind_clear: boolean);
begin
    if lv_pedido.TagString = '1' then
        exit;

    lv_pedido.TagString := '1'; // Em processamento...

    TThread.CreateAnonymousThread(procedure
    begin
        dm.qry_pedido.Active := false;
        dm.qry_pedido.SQL.Clear;
        dm.qry_pedido.SQL.Add('SELECT P.*, C.NOME');
        dm.qry_pedido.SQL.Add('FROM TAB_PEDIDO P');
        dm.qry_pedido.SQL.Add('JOIN TAB_CLIENTE C ON (C.COD_CLIENTE = P.COD_CLIENTE)');

        // Filtro...
        if busca <> '' then
        begin
            dm.qry_pedido.SQL.Add('WHERE ( C.NOME LIKE ''%'' || :BUSCA || ''%'' ');
            dm.qry_pedido.SQL.Add('      OR P.PEDIDO = :PEDIDO ) ');
            dm.qry_pedido.ParamByName('BUSCA').Value  := busca;
            dm.qry_pedido.ParamByName('PEDIDO').Value := busca;
        end;

        dm.qry_pedido.SQL.Add('ORDER BY PEDIDO_LOCAL DESC');
        dm.qry_pedido.SQL.Add('LIMIT :PAGINA, :QTD_REG');
        dm.qry_pedido.ParamByName('PAGINA').Value  := lv_pedido.Tag * 10;
        dm.qry_pedido.ParamByName('QTD_REG').Value := 10;
        dm.qry_pedido.Active := true;

        // Limpar listagem...
        if ind_clear then
            lv_pedido.Items.Clear;

        lv_pedido.Tag := lv_pedido.Tag + 1;
        lv_pedido.BeginUpdate;

        while NOT dm.qry_pedido.Eof do
        begin
            TThread.Synchronize(nil, procedure
            begin
                AddPedido(dm.qry_pedido.FieldByName('PEDIDO').AsString,
                      dm.qry_pedido.FieldByName('NOME').AsString,
                      FormatDateTime('dd/mm/yyyy', dm.qry_pedido.FieldByName('DATA').AsDateTime),
                      dm.qry_pedido.FieldByName('IND_ENTREGUE').AsString,
                      dm.qry_pedido.FieldByName('IND_SINC').AsString,
                      dm.qry_pedido.FieldByName('VALOR_TOTAL').AsFloat);
            end);

            dm.qry_pedido.Next;
        end;

        lv_pedido.EndUpdate;
        lv_pedido.TagString := ''; // Processamento terminou...

    end).Start;
end;

procedure TFrmPrincipal.lv_pedidoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
    if lv_pedido.Items.Count > 0 then
    begin
        if lv_pedido.GetItemRect(lv_pedido.Items.Count - 3).Bottom <= lv_pedido.Height then
            ListarPedido(edt_busca_pedido.Text, false);
    end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    TabControl.TabPosition := TTabPosition.None;
    TabControl.ActiveTab := TabPedido;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    SelecionaTab(img_tab_pedido);

    lv_pedido.Tag := 0;
    ListarPedido('', true);
end;

procedure TFrmPrincipal.img_busca_pedidoClick(Sender: TObject);
begin
    lv_pedido.Tag := 0;
    ListarPedido(edt_busca_pedido.Text, true);
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
