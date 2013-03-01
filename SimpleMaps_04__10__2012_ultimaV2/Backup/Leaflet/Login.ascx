<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Login.ascx.cs" Inherits="Leaflet.Login" %>
<link href="main.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
var timeout         = 500;
var closetimer		= 0;
var ddmenuitem      = 0;

// open hidden layer
function mopen(id)
{	
	// cancel close timer
	mcancelclosetime();

	// close old layer
	if(ddmenuitem) ddmenuitem.style.visibility = 'hidden';

	// get new layer and show it
	ddmenuitem = document.getElementById(id);
	ddmenuitem.style.visibility = 'visible';

}
// close showed layer
function mclose()
{
	if(ddmenuitem) ddmenuitem.style.visibility = 'hidden';
}

// go close timer
function mclosetime()
{
	closetimer = window.setTimeout(mclose, timeout);
}

// cancel close timer
function mcancelclosetime()
{
	if(closetimer)
	{
		window.clearTimeout(closetimer);
		closetimer = null;
	}
}
// close layer when click-out
document.onclick = mclose; 

    //Buscar Endereço
    function result_Click() {
        //var divResultado = document.getElementById("divResultado");
        //divResultado.innerHTML = "";
	    alert(this.result.formatted_address + "\n\nlat = " + this.result.lat + "\n\nlong = " + this.result.lng);
	    return true;
    }
    function btnBuscar_Click(){
	//divResultado = document.getElementById("divResultado");
	var txtEndereco = document.getElementById("txtEndereco");
	req = new XMLHttpRequest(), ends, i, div;
	    try {
		    req.open("GET", "Endereco.ashx?end=" + encodeURIComponent(txtEndereco.value), false);
		    req.send();
		    ends = eval(req.responseText);
		    if (ends.error) {
			    alert("Erro do servidor: " + ends.error);
		    } else {
			    //ends é um array!
		        //divResultado.innerHTML = "";
			    if (ends.length === 0) {
				    alert("Não foi possível encontrar seu endereço...");
			    } else if (ends.length === 1) {
			        txtEndereco.value = ends[0].formatted_address;
			        var cloudmadeUrl = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png',
    			    cloudmadeAttribution = 'SimpleMaps',
			        cloudmade = new L.TileLayer(cloudmadeUrl, {maxZoom: 18, attribution: cloudmadeAttribution});
    	            map.setView(new L.LatLng(ends[0].lat,ends[0].lng), 16).addLayer(cloudmade);
			    } else {
                    /*
                    div.appendChild(document.createTextNode("Foram encontrados vários endereços, escolha um:"));
				    divResultado.appendChild(div);
				    for (i = 0; i < ends.length; i++) {
					    div = document.createElement("div");
					    div.appendChild(document.createTextNode(ends[i].formatted_address));
					    div.result = ends[i];
					    div.onclick = result_Click;
					    divResult.appendChild(div);
                    */
				    }
			    }
		    }
	    }catch (ex) {
		    alert(ex);
	    }
	    return true;
    }

    function mostrarResultadoBusca() {
        document.getElementById('divResultado').style.visibility = 'visible';
    }
    function ocultarResultadoBusca() {
        document.getElementById('divResultado').style.visibility = 'hidden';
    }
//fim do buscar endereço
</script>

<%--   <div id="divResultado" class="escondedor"><table class="centralizadora"><tr><td align="center" valign="middle">
        <div id="div2" runat="server"><table style="width: 250pt; background-color: #EAECFF">
   </table></div></td></tr></table></div>
--%>

<div style="text-align: right;">
    <table style="float: left; text-align: center">
        <%if (!logado)
          { %>
        <tr style="text-align: center; width: 400pt">
            <td style="text-align: center; font-weight: bold; color: #FFFFFF;">
                <asp:Image ID="logo" runat="server" ImageUrl="Images/logofinal.png" ImageAlign="Right" />
            </td>
        </tr>
        <%}
          else
          {%>
        <tr>
            <td style="font-weight: bold; color: #FFFFFF;">
                <label for="textfield">
                    Buscar Endereço:</label>
                <input type="text" id="txtEndereco" style="width: 65%;" />
                <input id="btnBuscar" type="button" value="Buscar" onclick="btnBuscar_Click()" />
            </td>
        </tr>
        <tr>
            <td>
                <table style="border-color: #A6CAF0; border-bottom-style: solid;">
                    <tr>
                        <td>
                            <ul id="sddm">
                                <li onmouseover="mostraMenu('m1');" onmouseout="escondeMenu('m1');">
                                    <img src="images/marcador.png" alt="" width="48" height="48" />
                                    <div id="m1">
                                        <span onclick="menuPontoClick();">Inserir Marcador</span>
                                    </div>
                                </li>
                                <li onmouseover="mostraMenu('m2');" onmouseout="escondeMenu('m2');">
                                    <img src="images/formas.png" alt="" width="48" height="48" />
                                    <div id="m2">
                                        <span onclick="menuCirculoClick();">Desenhar Círculo</span> 
                                        <span onclick="menuRetanguloClick();">Desenhar Retângulo</span>
                                        <span onclick="menuTrianguloClick();">Desenhar Triângulo</span>
                                    </div>
                                </li>
                                <li onmouseover="document.getElementById('m3').style.display='block';" onmouseout="document.getElementById('m3').style.display='none';">
                                    <img src="images/foto.png" alt="" width="48" height="48" />
                                    <div id="m3">
                                        <span onclick="menuImagemClick();">Inserir Foto</span>
                                    </div>
                                </li>
                                <li onmouseover="document.getElementById('m4').style.display='block';" onmouseout="document.getElementById('m4').style.display='none';">
                                    <img src="images/audio.png" alt="" width="48" height="48" />
                                    <div id="m4">
                                        <span>Inserir Áudio</span>
                                    </div>
                                </li>
                                <li onmouseover="document.getElementById('m5').style.display='block';" onmouseout="document.getElementById('m5').style.display='none';">
                                    <img src="images/video.png" alt="" width="48" height="48" />
                                    <div id="m5">
                                        <span onclick="menuVideoClick();">Inserir Vídeo</span>
                                    </div>
                                </li>
                                <li onmouseover="document.getElementById('m6').style.display='block';" onmouseout="document.getElementById('m6').style.display='none';">
                                    <img src="images/gravador.png" alt="" width="48" height="48" />
                                    <div id="m6">
                                        <span>Inserir Gravação</span>
                                    </div>
                                </li>
                                <li onmouseover="document.getElementById('m7').style.display='block';" onmouseout="document.getElementById('m7').style.display='none';">
                                    <img src="images/salvar.gif" alt="" width="48" height="48" />
                                    <div id="m7">
                                        <span>Salvar Mapa</span>
                                    </div>
                                </li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <%} %>
    </table>
    <table style="display: inline-table; background-color: #EAECFF;">
        <%if (!logado)
          { %>
        <tr>
            <td colspan="2" style="text-align: center;">
                Área de Login
            </td>
        </tr>
        <tr>
            <td style="text-align: right;">
                E-mail:
            </td>
            <td>
                <asp:TextBox ID="txtEmailLogin" runat="server" Width="160pt" BorderColor="#999999"
                    BorderWidth="1px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td style="text-align: right;">
                Senha:
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtSenhaLogin" TextMode="Password" Width="160pt"
                    BorderColor="#999999" BorderWidth="1px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: right;">
                <asp:Button runat="server" ID="btnEntrar" Text="Entrar" OnClick="btnEntrar_Click" />
            </td>
        </tr>
        <% } %>
        <tr>
            <td colspan="2" style="text-align: right;">
                <asp:Label ID="lblMsgLogin" runat="server"></asp:Label>
            </td>
        </tr>
        <%if (logado)
          { %>
        <tr>
            <td colspan="2" style="text-align: right;">
                <asp:Label ID="lblLog" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: right;">
                <a href="#"><span class="textoPequeno">Alterar Cadastro</span></a><span class="textoPequeno">&nbsp;|&nbsp;
                </span><a href="sair.aspx"><span class="textoPequeno">Sair</span></a> <span class="textoPequeno">
                    <% lblMsgLogin.Text = ""; %></span>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Label ID="lblMapas" runat="server" Text="Mapas"></asp:Label>
                <asp:DropDownList ID="ddlMapas" runat="server" EnableViewState="true">
                </asp:DropDownList>
                <asp:Button ID="abrirMapa" runat="server" Text="Abrir" OnClick="abrirMapaSelecionado" />
                <br />
                <input type="button" value="Criar novo mapa" onclick="javascript:mostraEscondedorMapa();" />
                <br />
                <asp:Label ID="AlertaMapa" runat="server"></asp:Label>
            </td>
        </tr>
        <% }
          else
          { %>
        <tr>
            <td colspan="2" style="text-align: right;">
                <a href="#" class="textoPequeno">Esqueci minha senha</a>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: right;">
                <a href="#" onclick="javascript:mostraEscondedor();" class="textoPequeno">Não sou cadastrado</a>
            </td>
        </tr>
        <% } %>
    </table>
</div>
