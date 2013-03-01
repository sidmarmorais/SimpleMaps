<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Leaflet.Home" %>

<%@ Register Src="Login.ascx" TagName="Login" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>..::SimpleMAPS::..</title>
    <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <link rel="stylesheet" href="dist/leaflet.css" />
    <!--[if lte IE 8]><link rel="stylesheet" href="../dist/leaflet.ie.css" /><![endif]-->
    <link href="main.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    //<![CDATA[ 
    
        function CarregarFormas(){ // carrega todas as formas geometricas
            CarregarPonto();
            CarregarTriangulo();
            CarregarRetangulo();
            CarregarVideo();
            CarregarImagem();
        }
        
        // carrega ponto
        function CarregarPonto(){
            var nomeMapa = document.getElementById('txtNomeMapa').value;
            Leaflet.WSPrincipal.CarregaInformacoes(nomeMapa,CriarPontoCarregado); // ver se o nomeMapa está chegando no WebS
        }
        
        function CriarPontoCarregado(resultado){
            for(var a = 0; a < resultado.length; a++){
		                var markerLocation = new L.LatLng(resultado[a].latitude - (-0.00001),resultado[a].longitude- (-0.00001));
		                var marker = new L.Marker(markerLocation);
		                map.addLayer(marker);
		                marker.bindPopup(resultado[a].texto).openPopup();
            }
         }

        // carrega triangulo
        function CarregarTriangulo(){
            var nomeMapa = document.getElementById('txtNomeMapa').value;
            Leaflet.WSPrincipal.CarregarInfoTriangulo(nomeMapa,CriarTrianguloCarregado);
        }
        
        function CriarTrianguloCarregado(resultado){
            for(var r = 0; r < resultado.length; r++){
                var p1 = new L.LatLng(parseFloat(resultado[r].lat1),parseFloat(resultado[r].lng1));
	            var p2 = new L.LatLng(parseFloat(resultado[r].lat2),parseFloat(resultado[r].lng2));
	            var p3 = new L.LatLng(parseFloat(resultado[r].lat3),parseFloat(resultado[r].lng3));
                var polygonPoints2 = new Array(p1, p2, p3);
                var Tpolygon = new L.Polygon(polygonPoints2);
                map.addLayer(Tpolygon);
                Tpolygon.bindPopup(resultado[r].texto);
            }
        }

        // carrega retangulo
        function CarregarRetangulo(){
            var nomeMapa = document.getElementById('txtNomeMapa').value;
            Leaflet.WSPrincipal.CarregarInfoRetangulo(nomeMapa,CriarRetanguloCarregado);
        }
        
        function CriarRetanguloCarregado(resultado){
            for(var r = 0; r <= resultado.length; r++){
                var p1 = new L.LatLng(parseFloat(resultado[r].lat1),parseFloat(resultado[r].lng1));
	            var p2 = new L.LatLng(parseFloat(resultado[r].lat2),parseFloat(resultado[r].lng2));
	            var p3 = new L.LatLng(parseFloat(resultado[r].lat3),parseFloat(resultado[r].lng3));
	            var p4 = new L.LatLng(parseFloat(resultado[r].lat4),parseFloat(resultado[r].lng4));
	            
                var retanguloPoints = new Array(p1, p2, p3, p4);
                
                var RetanguloPontos = new L.Rectangle(retanguloPoints);
                map.addLayer(RetanguloPontos);
                RetanguloPontos.bindPopup(resultado[r].texto);
            }
        }
        
        // carrega video
        function CarregarVideo(){
            var nomeMapa = document.getElementById('txtNomeMapa').value;
            Leaflet.WSPrincipal.CarregarInfoVideo(nomeMapa,CriarVideoCarregado); // ver se o nomeMapa está chegando no WebS
        }
        
        function CriarVideoCarregado(resultado){
            for(var a = 0; a < resultado.length; a++){
		                var markerLocation = new L.LatLng(resultado[a].latitude - (-0.00001),resultado[a].longitude- (-0.00001));
		                var marker = new L.Marker(markerLocation);
		                map.addLayer(marker);
		                
		                var videoPart1 = "<object width='200' height='200'> <param name='movie' value='";
			            var videoPart2 = "'</param> <param name='allowFullScreen' value='true'></param> <embed src='";
			            var videoPart3 = "'type='application/x-shockwave-flash' allowfullscreen='true'  width='200' height='200'></embed> </object> <br/> ";
                        var corpoVideo = videoPart1+ videoPart2 + resultado[a].video + videoPart3 + resultado[a].texto;
		                
		                marker.bindPopup(corpoVideo).openPopup();
            }
         }

        // carrega Imagem
        function CarregarImagem(){
            var nomeMapa = document.getElementById('txtNomeMapa').value;
            Leaflet.WSPrincipal.CarregarInfoImagem(nomeMapa,CriarImagemCarregado);
        }
        
        function CriarImagemCarregado(resultado){
            for(var a = 0; a < resultado.length; a++){
		                var markerLocation = new L.LatLng(resultado[a].latitude - (-0.00001),resultado[a].longitude- (-0.00001));
		                var marker = new L.Marker(markerLocation);
		                map.addLayer(marker);

		                var imagem1 = "<IMG width='200' height='200' SRC='";
                        var imagem2 = "' /> <br/>";
                        var corpoMensagem1 = "<textarea style='border: 0; overflow: auto;' width = '150'>"
                        var corpoMensagem2 = "</textarea>";
                        var corpoImagem = imagem1 + linkImagem + imagem2 + corpoMensagem1 + textoMarcado + corpoMensagem2;
                        
                        imagemMarcador.bindPopup(corpoImagem);
            }
         }
                        
        function mostraEscondedor() {
            document.getElementById('escondedor').style.visibility = 'visible';
        }
        function ocultaEscondedor() {
            document.getElementById('escondedor').style.visibility = 'hidden';
        }
        
        function mostraEscondedorMapa() {
            document.getElementById('escondedorMapa').style.visibility = 'visible';
        }
        function ocultaEscondedorMapa() {
            document.getElementById('escondedorMapa').style.visibility = 'hidden';
        }
            
        function mostraResultado() {
        document.getElementById('divResult').style.visibility = 'visible';
        }
        function ocultaResultado() {
        document.getElementById('divResult').style.visibility = 'hidden';
        }
     //]]>
</script>
<script type="text/javascript" src="dist/leaflet.js"></script>
    
    
</head>
<body onload="CarregarFormas()" >
    <form id="form1" runat="server">
    <uc1:Login ID="Login1" runat="server" />
    <asp:HiddenField ID="txtNomeMapa" runat="server" />
    <asp:HiddenField ID="txtIdMapa" runat="server" />
    
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="WSPrincipal.asmx" />
            </Services>
        </asp:ScriptManager>
    </div>
    </form>
    <div id="map" style="width: 100%"></div>

    <div id="escondedor" class="escondedor"><table class="centralizadora"><tr><td align="center" valign="middle">
    <div id="div1" runat="server"><table style="width: 300pt; background-color: #EAECFF"><tr>
                <td colspan="2" style="text-align: center">
                    Realizar Cadastro
                </td>
            </tr>
            <tr>
                <td style="width: 90pt; text-align:right">
                    E-mail:
                </td>
                <td>
                    <input type="text" id="txtEmail" runat="server" class="txtCadastro" />
                </td>
            </tr>
            <tr>
                <td style="text-align:right">
                Senha:
                </td>
                <td>
                    <input type="password" id="txtSenha" runat="server" class="txtCadastro" />
                </td>
            </tr>
            <tr>
                <td style="text-align:right">
                Repetir senha:
                </td>
                <td>
                   <input type="password" id="txtRepeteSenha" runat="server" class="txtCadastro" />
                </td>
            </tr>
            <tr>
                <td colspan="2" align="right">
                    <a href="#" onclick="javascript:cadastro();"><img src="Images/salvar_5.png" alt="Salvar" /></a>
                    <a onclick="javascript:ocultaEscondedor();" href="#"><img src="Images/excluir_3.png" alt="Fechar" /></a>
                </td>
            </tr>
            <tr>
            </tr>
        </table>
    </div>
    </td></tr></table></div>
    <div id="escondedorMapa" class="escondedor"><table class="centralizadora"><tr><td align="center" valign="middle">
        <div id="div2" runat="server"><table style="width: 250pt; background-color: #EAECFF">
         <tr><td>Nome do Mapa:</td>
             <td>
                <input type="text" id="nome_novo_mapa" style="width: 140pt"/>
             </td>
         </tr>
         <tr>
            <td colspan="2" align="right">
            <input type="button" id="btnok" value="Ok" onclick="javascript:CriarMapa();" />
            <input type="button" id="btncancel" value="Cancelar" onclick="javascript:ocultaEscondedorMapa();" /></td>
         </tr>
   </table></div></td></tr></table></div>
    
    
    
   <div id="divResult" class="escondedor" style="width: 100%; height: 100%"></div>
 
 
 
<script type="text/javascript">
		var map = new L.Map('map');
		var cloudmadeUrl = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png',
			cloudmadeAttribution = 'SimpleMaps';
			cloudmade = new L.TileLayer(cloudmadeUrl, {maxZoom: 18, attribution: cloudmadeAttribution});

		map.setView(new L.LatLng(-23.577813,-46.644752), 13).addLayer(cloudmade);

		var markerLocation = new L.LatLng(-23.577813,-46.644752);
		var marker = new L.Marker(markerLocation);
		map.addLayer(marker);
		
		marker.bindPopup("<b>Aqui é a BandTec!").openPopup();

		map.on('click', onMapClick);

		var popup = new L.Popup();
    
        // CRIAR NOVO MAPA 
        function CriarMapa(){
           var nomemp = document.getElementById('nome_novo_mapa').value;
           Leaflet.WSPrincipal.NovoMapa(nomemp,okmapa, erromapa);
        }
        function okmapa(e) {
            window.location.href = e.toString();
        }
        function erromapa(e) {
            //alert(e.toString());
        }
    
        // Realiza um novo cadastro
        function cadastro(){
           var email = document.getElementById('txtEmail').value;
           var senha = document.getElementById('txtSenha').value;
           var rptSenha = document.getElementById('txtRepeteSenha').value;
           
           Leaflet.WSPrincipal.novoCadastro(email, senha, rptSenha, OkCadastro, ErroCadastro);
           ocultaEscondedor();
        }
        function OkCadastro(e) {
           //alert(e.toString());
        }
        function ErroCadastro(e) {
           // alert(e.toString());
        }

		//Variaveis Globais
		var texto ='';
		var lat;
		var lng;
		var regiao;
		var circuloPontox;
		var circuloPontoy;
		var Tponto1x;
		var Tponto1y;
		var Tponto2x;
		var Tponto2y;
		var Tponto3x;
		var Tponto3y;
		var Retangulo1x;
		var Retangulo1y;
		var Retangulo2x;
		var Retangulo2y;
		var Retangulo3x;
		var Retangulo3y;
		var Retangulo4x;
		var Retangulo4y;
		var video1;
		var video2;
		var video3;
		var VideoLat;
		var VideoLng;
		var imagem1;
		var imagem2;
		var imagemLink;
		var videoBotoes;
		var videoLink;
		var ImagemLat;
		var ImagemLng;
		
		var acao = {
		    atual: null,
		    NADA: function (e) {
		        return false;
		    },
		    PONTO: function (e) {
		        acao.atual = acao.NADA;
			    lat = e.latlng.lat.toFixed(6) - (-0.00001);
			    lng = e.latlng.lng.toFixed(6) - (-0.00001);
			    return criarPonto();
	        },
	        REMOVE: function (e) {
		        acao.atual = acao.NADA;
			    lat = e.latlng.lat.toFixed(6) - (-0.00001);
			    lng = e.latlng.lng.toFixed(6) - (-0.00001);
			    return RemoveForma();
			},
		    VIDEO: function (e) {
		        acao.atual = acao.NADA;
			    VideoLat = e.latlng.lat.toFixed(6) - (-0.00001);
			    VideoLng = e.latlng.lng.toFixed(6) - (-0.00001);
			    return criarVideo();
			},
		    IMAGEM: function (e) {
		        acao.atual = acao.NADA;
			    ImagemLat = e.latlng.lat.toFixed(6) - (-0.00001);
			    ImagemLng = e.latlng.lng.toFixed(6) - (-0.00001);
			    return criarImagem();
		    },
		    TRIANGULO: function (e) {
				acao.atual = acao.TRIANGULO2;
				Tponto1x = e.latlng.lat.toFixed(6) - (-0.00001);
				Tponto1y = e.latlng.lng.toFixed(6) - (-0.00001);
				return false;
		    },
		    TRIANGULO2: function (e) {
				acao.atual = acao.TRIANGULO3;
				Tponto2x = e.latlng.lat.toFixed(6) - (-0.00001);
				Tponto2y = e.latlng.lng.toFixed(6) - (-0.00001);
				return false;
		    },
		    TRIANGULO3: function (e) {
				acao.atual = acao.NADA;
				Tponto3x = e.latlng.lat.toFixed(6) - (-0.00001);
				Tponto3y = e.latlng.lng.toFixed(6) - (-0.00001);
				return criarTriangulo();
		    },
	        CIRCULO: function (e) {
		        //Funcionalidade não está completa
                /*acao.atual = acao.CIRCULO2;
			    lat = e.latlng.lat.toFixed(6) - (-0.00001);
			    lng = e.latlng.lng.toFixed(6) - (-0.00001);
			    regiao = document.createElement("div");
			    regiao.className = "floatDiv";
			    regiao.style.width = "100px";
			    regiao.style.height = "100px";
			    regiao.style.left = e.layerPoint.x + "px";
			    regiao.style.top = e.layerPoint.y + "px";
			    regiao.style.zIndex = 6;
			    var m = document.getElementById("map");
			    m.appendChild(regiao);
			    attachObserver(m, "mousemove", circuloMouseMove, true);
			    return false;*/
	        },
	        CICULO2: function (e) {
	            //return false;
	        },
		    RETANGULO: function (e) {
				acao.atual = acao.RETANGULO2;
				Retangulo1x = e.latlng.lat.toFixed(6) - (-0.00001);
				Retangulo1y = e.latlng.lng.toFixed(6) - (-0.00001);
				return false;
		    },
		    RETANGULO2: function (e) {
				acao.atual = acao.RETANGULO3;
				Retangulo2x = e.latlng.lat.toFixed(6) - (-0.00001);
				Retangulo2y = e.latlng.lng.toFixed(6) - (-0.00001);
				return false;
		    },
		    RETANGULO3: function (e) {
				acao.atual = acao.RETANGULO4;
				Retangulo3x = e.latlng.lat.toFixed(6) - (-0.00001);
				Retangulo3y = e.latlng.lng.toFixed(6) - (-0.00001);
				return false;
		    },
		    RETANGULO4: function (e) {
				acao.atual = acao.NADA;
				Retangulo4x = e.latlng.lat.toFixed(6) - (-0.00001);
				Retangulo4y = e.latlng.lng.toFixed(6) - (-0.00001);
				return criarRetangulo();
		    }
		};
		acao.atual = acao.NADA;
		var poligno = false;
		var remove = false;
		var video = false;
		var imagem = false;
	
		function mostraMenu(id) {
		    document.getElementById(id).style.display = "block";
		}
		function escondeMenu(id) {
		    document.getElementById(id).style.display = "none";
		}
		function menuPontoClick() {
            acao.atual = acao.PONTO;
            escondeMenu("m1");
		}
		function menuCirculoClick() {
            acao.atual = acao.CIRCULO;
            escondeMenu("m2");
		}
		function menuTrianguloClick() {
            acao.atual = acao.TRIANGULO;
            escondeMenu("m2");
		}
		function menuRetanguloClick() {
            acao.atual = acao.RETANGULO;
            escondeMenu("m2");
		}
		function menuImagemClick() {
            acao.atual = acao.IMAGEM;
            escondeMenu("m3");
		}
		function menuVideoClick() {
            acao.atual = acao.VIDEO;
            escondeMenu("m5");
		}
		function circuloMouseMove(e) {
		    var l = parseInt(regiao.style.left);
		    var t = parseInt(regiao.style.top);
		    regiao.style.width = (e.layerX - l) + "px";
		    regiao.style.height = (e.layerY - t) + "px";
		    return true;
		}
		function attachObserver(element, eventName, func, capturePhase) {
		    if (element.addEventListener) {
		        return element.addEventListener(eventName, func, capturePhase ? true : false);
		    } else {
		        return element.attachEvent("on" + eventName, func);
		    }
		}
		function detachObserver(element, eventName, func, capturePhase) {
		    if (element.removeEventListener)
		    {
		        return element.removeEventListener(eventName, func, capturePhase ? true : false);
		    } else {
		        return element.detachEvent("on" + eventName, func);
		    }
		}
		function onMapClick(e) {
		    acao.atual(e);
		}

        // Criar ponto de marcação
        var markerSMPonto;
	    function criarPonto(){
           var markerLocationSM = new L.LatLng(lat, lng);
           markerSMPonto = new L.Marker(markerLocationSM);
           map.addLayer(markerSMPonto);
           markerSMPonto.bindPopup("<input type='text' name='texto' id='marcaTexto' value=''/> <br/> <input type='button' name='pontoButton' id='idButton' value='Salvar' onclick='inserirPonto();'/> <input type='button' name='pontoButton' id='cancelarPonto' value='Cancelar' onclick='cancelarMarcacaoPonto();'/>" ).openPopup();  
        }
         function cancelarMarcacaoPonto(){
            markerSMPonto.closePopup();
            map.removeLayer(markerSMPonto);
        }
        function inserirPonto(){
            var id_mapa = document.getElementById('txtIdMapa').value;
            var textoMarcado = document.getElementById('marcaTexto').value;
            
            Leaflet.WSPrincipal.MarcaPontoPersistencia(lat, lng, textoMarcado, id_mapa, OkPonto, ErroPonto);
            markerSMPonto.bindPopup(textoMarcado);
            map.closePopup(markerSMPonto);
        }
        function OkPonto(e) {
           //alert(e.toString());
        }
        function ErroPonto(e) {
           // alert(e.toString());
        }

        //marca ponto ao realizar busca
        function inserirPontoBusca(latitude, longitude) {
            acao.atual = acao.NADA;
            lat = latitude;
            lng = longitude;
            return criarPonto();
        }

         /**
         * Created by: http://gustavopaes.net
         * Created on: Nov/2009
         * Retorna os valores de parâmetros passados via url.
         * @param String Nome da parâmetro.
         */
        function _GET(name)
        {
          var url   = window.location.search.replace("?", "");
          var itens = url.split("&");
          for(n in itens)
          {
            if( itens[n].match(name) ){
              return decodeURIComponent(itens[n].replace(name+"=", ""));
            }
          }
          return null;
        }

        // Criar Circulo
		function criarCirculo(){
			raio = document.getElementById('raio').value;
			var circleLocation = new L.LatLng(lat,lng),
			circleOptions = {color: '#f03', opacity: 0.7},
			circle = new L.Circle(circleLocation,raio, circleOptions);
		
			circle.bindPopup(texto);
			map.addLayer(circle);
			document.getElementById('raio').disabled=true;
			limpaTexto();
		}

        // Criar Triangulo
        var polygon;
		function criarTriangulo(){
			var p1 = new L.LatLng(Tponto1x,Tponto1y);
			var	p2 = new L.LatLng(Tponto2x,Tponto2y);
			var	p3 = new L.LatLng(Tponto3x,Tponto3y);
			
			var polygonPoints = new Array(p1, p2, p3);
			polygon = new L.Polygon(polygonPoints);			
			map.addLayer(polygon);
			polygon.bindPopup("<input type='text' name='texto' id='marcaTextoTriangulo' value=''/> <br/> <input type='button' name='trianguloNameButton' id='idTriangulo' value='Salvar' onclick='inserirTriangulo();'/> <input type='button' name='btnCancelarTriangulo' id='cancelarTriangulo' value='Cancelar' onclick='cancelarMarcacaoTriangulo();'/>").openPopup();
		}
        function cancelarMarcacaoTriangulo(){
            map.closePopup();
            map.removeLayer(polygon);
        }
        function inserirTriangulo(){
            var id_mapa = document.getElementById('txtIdMapa').value;
            var textoMarcado = document.getElementById('marcaTextoTriangulo').value;
            Leaflet.WSPrincipal.MarcaTrianguloPersistencia(Tponto1x, Tponto1y,Tponto2x, Tponto2y,Tponto3x, Tponto3y, textoMarcado, id_mapa, OkPonto, ErroPonto);
            polygon.bindPopup(textoMarcado);
            map.closePopup(polygon);
        }
        
        // Criar Retangulo
        var retangulo;
		function criarRetangulo(){
			var p1 = new L.LatLng(Retangulo1x,Retangulo1y);
			var	p2 = new L.LatLng(Retangulo2x,Retangulo2y);
			var	p3 = new L.LatLng(Retangulo3x,Retangulo3y);
			var	p4 = new L.LatLng(Retangulo4x,Retangulo4y);
			
			var polygonPoints = new Array(p1, p2, p3, p4);
			retangulo = new L.Rectangle(polygonPoints);			
			map.addLayer(retangulo);
			retangulo.bindPopup("<input type='text' name='texto' id='marcaTextoRetangulo' value=''/> <br/> <input type='button' name='retanguloNameButton' id='idRetangulo' value='Salvar' onclick='inserirRetangulo();'/> <input type='button' name='btnCancelarRetangulo' id='cancelarRetangulo' value='Cancelar' onclick='cancelarMarcacaoRetangulo();'/>").openPopup();
		}
        function cancelarMarcacaoRetangulo(){
            map.closePopup();
            map.removeLayer(retangulo);
        }
        function inserirRetangulo(){
            var id_mapa = document.getElementById('txtIdMapa').value;
            var textoMarcado = document.getElementById('marcaTextoRetangulo').value;
            Leaflet.WSPrincipal.MarcaRetanguloPersistencia(Retangulo1x, Retangulo1y,Retangulo2x, Retangulo2y,Retangulo3x, Retangulo3y,Retangulo4x, Retangulo4y, textoMarcado, id_mapa, OkPonto, ErroPonto);
            retangulo.bindPopup(textoMarcado);
            map.closePopup(retangulo);
        }

        //cria video
        var videoMarcador;
		function criarVideo(){
			var latLng = new L.LatLng(VideoLat, VideoLng);
			videoMarcador = new L.Marker(latLng);
			map.addLayer(videoMarcador);
			videoMarcador.bindPopup("<table ><tr><td width='80' align='right'>Link:</td><td><input type='text' name='linkVideo' id='idLinkVideo' value=''/></td></tr><tr><td width='80' align='right'>Comentario:</td><td><input type='text' name='texto' id='marcaTextoVideo' value=''/></td></tr><tr><td width ='80' align = 'center' colspan='2'> <input type='button' name='videoNameButton' id='idVideo' value='Salvar' onclick='inserirVideo();'> <input type='button' name='btnCancelarVideo' id='cancelarVideo' value='Cancelar' onclick='cancelarMarcacaoVideo();'/></td></tr>").openPopup();
		}
		
		function cancelarMarcacaoVideo(){
            map.closePopup();
            map.removeLayer(videoMarcador);
        }
        
        function inserirVideo(){
            var id_mapa = document.getElementById('txtIdMapa').value;
            var textoMarcado = document.getElementById('marcaTextoVideo').value;
            var linkVideo = document.getElementById('idLinkVideo').value;
            linkVideo = linkVideo.replace("watch?v=","v/"); // trata o link, aparece soh o video =)
            Leaflet.WSPrincipal.MarcaVideoPersistencia(VideoLat, VideoLng, textoMarcado, linkVideo, id_mapa, OkPonto, ErroPonto);
            
            video1 = "<object width='200' height='200'> <param name='movie' value='";
			video2 = "'</param> <param name='allowFullScreen' value='true'></param> <embed src='";
			video3 = "'type='application/x-shockwave-flash' allowfullscreen='true'  width='200' height='200'></embed> </object> <br/> ";
            var corpoVideo = video1+ video2+linkVideo+video3 + textoMarcado;
            videoMarcador.bindPopup(corpoVideo);
            map.closePopup(videoMarcador);
        }
        
        // insere imagem
        var imagemMarcador;
		function criarImagem(){
			var latLng = new L.LatLng(ImagemLat, ImagemLng);
			imagemMarcador = new L.Marker(latLng);
			map.addLayer(imagemMarcador);
			imagemMarcador.bindPopup("<table ><tr><td width='80' align='right'>Link:</td><td><input type='text' name='linkImagem' id='idLinkImagem' value=''/></td></tr><tr><td width='80' align='right'>Comentario:</td><td><input type='text' name='texto' id='marcaTextoImagem' value=''/></td></tr><tr><td width ='80' align = 'center' colspan='2'> <input type='button' name='imagemNameButton' id='idImagem' value='Salvar' onclick='inserirImagem();'> <input type='button' name='btnCancelarImagem' id='cancelarImagem' value='Cancelar' onclick='cancelarMarcacaoImagem();'/></td></tr>").openPopup();
		}
		
		function cancelarMarcacaoImagem(){
            map.closePopup();
            map.removeLayer(imagemMarcador);
        }
        
        function inserirImagem(){
            var id_mapa = document.getElementById('txtIdMapa').value;
            var textoMarcado = document.getElementById('marcaTextoImagem').value;
            var linkImagem = document.getElementById('idLinkImagem').value;
            
            Leaflet.WSPrincipal.MarcaImagemPersistencia(ImagemLat, ImagemLng, textoMarcado, linkImagem, id_mapa, OkPonto, ErroPonto);
            
            var imagem1 = "<IMG width='200' height='200' SRC='";
            var imagem2 = "' /> <br/>";
            var corpoMensagem1 = "<textarea style='border: 0; overflow: auto;' width = '150'>"
            var corpoMensagem2 = "</textarea>";
            var corpoImagem = imagem1 + linkImagem + imagem2 + corpoMensagem1 + textoMarcado + corpoMensagem2;
            imagemMarcador.bindPopup(corpoImagem);
            map.closePopup(imagemMarcador);
        }
        
        
/*  (((((((((((((((((((((((((((((((((((((((nao apagar, feito pelo mion, pode ser usado no futuro))))))))))))))))))))))))
		function criarImagem(){
               var markerLocationSM = new L.LatLng(ImagemLat, ImagemLng);
               var markerSM = new L.Marker(markerLocationSM);
               map.addLayer(markerSM);

               markerSM.bindPopup("<iframe style=\"border: 0px;\" src=\"Upload.aspx\" ></iframe>").openPopup();
               //inicio
               var id_mapa = document.getElementById('txtIdMapa').value;
               Leaflet.WSPrincipal.SalvarImagem(ImagemLat, ImagemLng, id_mapa, OkImagem, ErroPonto);
               // fim
       }

		function inserirImagem(){
		    var nomeImagem = document.getElementById("idNomeImagem").value;
		    var linkImagem = document.getElementById("idLinkImagem").value;

            var id_mapa = document.getElementById('txtIdMapa').value;
		    Leaflet.WSPrincipal.salvarImagem(ImagemLat, ImagemLng, nomeImagem, linkImagem,id_mapa,OkImagem, ErroImagem);
		}
		
		function OkImagem(e) {
           alert(e.toString());
        }
        function ErroImagem(e) {
           alert(e.toString());
        }
***************/
        
		function limpaPoligno(){
			Tponto1x = 0;
			Tponto1y = 0;
			Tponto2x = 0;
			Tponto2y = 0;
			Tponto3x = 0;
			Tponto3y = 0;
		}

		function limpaRetangulo(){
			Retangulo1x = 0;
			Retangulo1y = 0;
			
			Retangulo2x = 0;
			Retangulo2y = 0;
			
			Retangulo3x = 0;
			Retangulo3y = 0;
			
			Retangulo4x = 0;
			Retangulo4y = 0;
		}
		function limpaTexto(){
			document.getElementById('texto').value='';
		}

        // Calculo do raio do Círculo deve ser usado: a teoria do mano Pitágoras para calcular a distância entre 2 pontos.
        // Pelo Teorema de Pitágoras temos: “o quadrado da hipotenusa é igual à soma dos quadrados dos catetos”
        function pitagoras() {
            a = document.pythagorean
            b = a.a.value
            c = a.b.value
            c=parseInt(c)
            b=parseInt(b)
            b = b*b
            c = c*c
            d = b+c
            e = Math.sqrt(d)
            document.pythagorean.theorem.value = e
        }
	</script>
</body>
</html>