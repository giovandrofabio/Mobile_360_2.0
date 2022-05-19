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
    edt_busca_cliente: TEdit;
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
    img_busca_cliente: TImage;
    procedure img_tab_pedidoClick(Sender: TObject);
    procedure SelecionaTab(img : TImage);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddPedido(pedido, cliente, dt_pedido, ind_entregue, ind_sinc : string;
                        valor : double);
    procedure AddCliente(cod_cliente,nome, endereco, cidade, fone: string);
    procedure ListarPedido(busca : string; ind_clear : boolean; delay : Integer);
    procedure ListarCliente(busca: string; ind_clear: boolean; delay : Integer);
    procedure img_busca_pedidoClick(Sender: TObject);
    procedure lv_pedidoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure img_busca_clienteClick(Sender: TObject);
    procedure lv_clientesPaint(Sender: TObject; Canvas: TCanvas;
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
                txt.Text := 'Orçamento';

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

procedure TFrmPrincipal.AddCliente(cod_cliente,nome, endereco, cidade, fone: string);
var
    item : TListViewItem;
    txt : TListItemText;
begin
    try
        item := lv_clientes.Items.Add;

        with item do
        begin
            // Nome...
            txt := TListItemText(Objects.FindDrawable('TxtNome'));
            txt.Text := nome;

            // Endereço...
            txt := TListItemText(Objects.FindDrawable('TxtEndereco'));
            txt.Text := endereco + ' - ' + cidade;

            // Fone...
            txt := TListItemText(Objects.FindDrawable('TxtFone'));
            txt.Text := fone;

        end;
    except on ex:exception do
        showmessage('Erro ao inserir Cliente na lista: ' + ex.Message);
    end;
end;

procedure TFrmPrincipal.ListarCliente(busca: string; ind_clear: boolean; delay : Integer);
begin
    if lv_clientes.TagString = '1' then
        exit;

    lv_clientes.TagString := '1'; // Em processamento...

    TThread.CreateAnonymousThread(procedure
    begin
        sleep(delay);

        dm.qry_cliente.Active := false;
        dm.qry_cliente.SQL.Clear;
        dm.qry_cliente.SQL.Add('SELECT C.* ');
        dm.qry_cliente.SQL.Add('FROM TAB_CLIENTE C');

        // Filtro...
        if busca <> '' then
        begin
            dm.qry_cliente.SQL.Add('WHERE C.NOME LIKE ''%'' || :BUSCA || ''%'' ');
            dm.qry_cliente.ParamByName('BUSCA').Value  := busca;
        end;

        dm.qry_cliente.SQL.Add('ORDER BY NOME ');
        dm.qry_cliente.SQL.Add('LIMIT :PAGINA, :QTD_REG');
        dm.qry_cliente.ParamByName('PAGINA').Value  := lv_clientes.Tag * 15;
        dm.qry_cliente.ParamByName('QTD_REG').Value := 15;
        dm.qry_cliente.Active := true;

        // Limpar listagem...
        if ind_clear then
            lv_clientes.Items.Clear;

        lv_clientes.Tag := lv_clientes.Tag + 1;
        lv_clientes.BeginUpdate;

        while NOT dm.qry_cliente.Eof do
        begin
            TThread.Synchronize(nil, procedure
            begin
                AddCliente(dm.qry_cliente.FieldByName('COD_CLIENTE').AsString,
                           dm.qry_cliente.FieldByName('NOME').AsString,
                           dm.qry_cliente.FieldByName('ENDERECO').AsString,
                           dm.qry_cliente.FieldByName('CIDADE').AsString,
                           dm.qry_cliente.FieldByName('FONE').AsString);
            end);

            dm.qry_cliente.Next;
        end;

        lv_clientes.EndUpdate;
        lv_clientes.TagString := ''; // Processamento terminou...

    end).Start;
end;

procedure TFrmPrincipal.ListarPedido(busca: string; ind_clear: boolean; delay : Integer);
begin
    if lv_pedido.TagString = '1' then
        exit;

    lv_pedido.TagString := '1'; // Em processamento...

    TThread.CreateAnonymousThread(procedure
    begin
        sleep(delay);

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

procedure TFrmPrincipal.lv_clientesPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
    if lv_clientes.Items.Count > 0 then
    begin
        if lv_clientes.GetItemRect(lv_clientes.Items.Count - 3).Bottom <= lv_clientes.Height then
            ListarCliente(edt_busca_cliente.Text, false,0);
    end;
end;

procedure TFrmPrincipal.lv_pedidoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
    if lv_pedido.Items.Count > 0 then
    begin
        if lv_pedido.GetItemRect(lv_pedido.Items.Count - 3).Bottom <= lv_pedido.Height then
            ListarPedido(edt_busca_pedido.Text, false,0);
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
    ListarPedido('', true, 0);

    lv_clientes.Tag := 0;
    ListarCliente('', true, 1500);
end;

procedure TFrmPrincipal.img_busca_clienteClick(Sender: TObject);
begin
   lv_clientes.Tag := 0;
   ListarCliente(edt_busca_cliente.Text, True,0);
end;

procedure TFrmPrincipal.img_busca_pedidoClick(Sender: TObject);
begin
    lv_pedido.Tag := 0;
    ListarPedido(edt_busca_pedido.Text, true,0);
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
