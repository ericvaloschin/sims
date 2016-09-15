//eric
class Sims {
	var sexo
	var edad
	var amigos = []
	var nivelDeFelicidad
	var personalidad
	var dinero
	var estado = normalidad
	var pareja
	var sexoPreferencia
	var informacion = []
	var trabajo
	var relacion = sinPareja
	constructor(sexoC, felicadadC, edadC, personalidadC, sexoPreferenciaC, trabajoC, dineroC){
		sexo = sexoC
		edad = edadC
		nivelDeFelicidad = felicadadC
		personalidad = personalidadC
		sexoPreferencia = sexoPreferenciaC
		trabajo = trabajoC
		dinero = dineroC
	}
	method pareja(){
		return pareja
	}
	method trabajo(){
		return trabajo
	}
	method relacion(){
		return relacion
	}
	method trabajar(){
		trabajo.tipoTrabajo().trabajar(self)
	}
	method informacion(){
		return estado.informacion(informacion)
	}
	method estado(){
		return estado
	}
	method valoracion(unSims){
		return personalidad.valorar(self, unSims)
	}
	method leInteresa(unSims){
		return personalidad.leInteresa(self, unSims)
	}
	method dinero(){
		return dinero
	}
	method sexo(){
		return sexo
	}
	method sexoPreferencia(){
		return sexoPreferencia
	}
	method personalidad(){
		return personalidad
	}
	method amigos(){
		return amigos
	}
	method edad(){
		return edad
	}
	method nivelDeFelicidad(){
		return estado.nivelDeFelicidad(nivelDeFelicidad)
	}
	method agregarAmigo(unAmigo){
		amigos.add(unAmigo)
	}
	method cambiarRelacion(unaRelacion){
		relacion = unaRelacion
	}
	method aumentarFelicidad(nivel){
		nivelDeFelicidad += nivel
	}
	method disminuirFelicidad(nivel){
		nivelDeFelicidad -= nivel
	}
	
	method cambiarDinero(nuevoDinero){
		dinero += nuevoDinero
	}
	method quienesLeGustan(listaPersonas){
		return listaPersonas.filter({unSims => self.leInteresa(unSims)})
	}
	method cambiarEstado(nuevoEstado){
		if(estado == nuevoEstado) {
  		error.throwWithMessage("ya tiene este estado")
  		}
  		if(not(nuevoEstado == normalidad)) {
  		self.seLeFueElEstado()
  		}
  		estado = nuevoEstado
	}
	method seLeFueElEstado(){
		estado = normalidad
	}
	method cambiarPareja(nuevaPareja){
		pareja = nuevaPareja
	}
	method amigosDeFierro(){
		return amigos.take(4)
	}
	method nuevosAmigos(){
		return amigos.drop(amigos.size() - 4)
	}
	method cambiarAmigos(nuevosAmigos){
		amigos = nuevosAmigos
	}
	method esAmigo(unAmigo){
		return amigos.contains(unAmigo)
	}
	method amigoQueMasValora(){
		return amigos.max({unAmigo => self.valoracion(self)})
	}
	method popularidad(){
		return amigos.sum({unAmigo => unAmigo.nivelDeFelicidad()})
	}
	method esElMasPopular(){
		var popularidadDelSims = self.popularidad()
		return amigos.all({unAmigo => popularidadDelSims > unAmigo.popularidad()})
	}
	method contarInformacion(unaInformacion){
		if(not(self.tieneInformacion(unaInformacion))){
			informacion.add(unaInformacion)
		}
	}
	method cuanConocedor(){
		return informacion.map({unaInfo => unaInfo.size()}).sum()
	}
	method amnesia(){
		informacion = []
	}
	method tieneInformacion(unaInformacion){
		return informacion.contains(unaInformacion)
	}
}
object amistad{
	method hacerAmigo(unSims, otroSims){
		var aumento = self.calcularNivel(unSims, otroSims)
		unSims.agregarAmigo(otroSims)
		unSims.aumentarFelicidad(aumento)
	}
	method seHacenAmigos(unSims, otroSims){
		self.hacerAmigo(unSims, otroSims)
		self.hacerAmigo(otroSims, unSims)
	}
	method calcularNivel(unSims, otroSims){
		return unSims.valoracion(otroSims)
	}
}
class Atraccion{
	method esSexoPreferencia(unSims, otroSims){
		return unSims.sexoPreferencia() == otroSims.sexo()
	}
}
object interesado inherits Atraccion{
	method valorar(unSims, otroSims){
		return otroSims.amigos().sum({unAmigo => unAmigo.dinero()})*0.1
	}
	method leInteresa(unSims, otroSims){
		var sexoPreferencia = self.esSexoPreferencia(unSims, otroSims)
		var duplicaDinero = otroSims.dinero()*2 >= unSims.dinero()
		return sexoPreferencia && duplicaDinero
	}
}
object superficial  inherits Atraccion{
	method valorar(unSims, otroSims){
		return otroSims.popularidad()*20
	}
	method leInteresa(unSims, otroSims){
		var sexoPreferencia = self.esSexoPreferencia(unSims, otroSims)
		var masPopular = self.amigoMasPopular(unSims).popularidad() < otroSims.popularidad() 
		var enRangoDeEdad = otroSims.edad() > 18 && otroSims.edad() < 29
		return sexoPreferencia && masPopular && enRangoDeEdad
	}
	method amigoMasPopular(unSims){
		return unSims.amigos().max({unSim => unSim.popularidad()})
	}
}

object buenazo inherits Atraccion{
	method valorar(unSims, otroSims){
		return unSims.nivelDeFelicidad()/2
	}
	method leInteresa(unSims, otroSims){
		return self.esSexoPreferencia(unSims, otroSims)
	}
}

object peleadoConLaVida  inherits Atraccion{
	method valorar(unSims, otroSims){
		return 0
	}
	method leInteresa(unSims, otroSims){
		var sexoPreferencia = self.esSexoPreferencia(unSims, otroSims)
		var esInfeliz = otroSims.nivelDeFelicidad() < 200
		return sexoPreferencia && esInfeliz
	}
}


object abrazoComun{
	method abrazar(unSims, otroSims){
		unSims.aumentarFelicidad(2)
		otroSims.aumentarFelicidad(4)
	}
}

object abrazoProlongado{
	method abrazar(unSims, otroSims){
		if(otroSims.leInteresa(unSims)){
			otroSims.cambiarEstado(soniador)
		}
		else{
			otroSims.cambiarEstado(incomodidad)
		}
	}
}
class Relacion{
	var unSims
	var otroSims
	var nuevosAmigos = []
	constructor(unSimsC, otroSimsC){
		unSims = unSimsC
		otroSims = otroSimsC
		
	}
	method comenzarRelacion(){
		unSims.cambiarPareja(otroSims)
		otroSims.cambiarPareja(unSims)
		unSims.cambiarRelacion(self)
		otroSims.cambiarRelacion(self)
	}
	method estaEnRelacion(unSimsCualquiera){
		return unSimsCualquiera == unSims || unSimsCualquiera == otroSims
	}
	method nuevosAmigos(){
		unSims.amigos().forEach({unAmigo => nuevosAmigos.add(unAmigo)})
	var sinRepetidos = otroSims.amigos().filter({unAmigo => not(nuevosAmigos.contains(unAmigo))})
		sinRepetidos.forEach({unAmigo => nuevosAmigos.add(unAmigo)})
		return nuevosAmigos
		}
	method miembros(){
			return [unSims, otroSims]
	}
	method funcionaRelacion(){
		return unSims.leInteresa(otroSims) &&  otroSims.leInteresa(unSims)
	}
	method sePudreTodo(){
		return not(self.funcionaRelacion()) && self.algunoPuedeSerInfiel()
	}
	method terminarRelacion(){
		unSims.cambiarPareja(soltero)
		otroSims.cambiarPareja(soltero)
		unSims.cambiarRelacion(sinPareja)
		otroSims.cambiarRelacion(sinPareja)
	}
	method reiniciarRelacion(){
		unSims.relacion().terminarRelacion()
		otroSims.relacion().terminarRelacion()
		self.comenzarRelacion()
	}
	
	method terminoLaRelacion(){
		return not(unSims.pareja() == otroSims) 
	}
	method algunoPuedeSerInfiel(){
		return nuevosAmigos.any({otrSims => unSims.leInteresa(otrSims)}) || nuevosAmigos.any({otrSims => otroSims.leInteresa(otrSims)})
	}
}
class Trabajar{
	method porSerBuenazo(unSims){
		if(unSims.personalidad() == buenazo && unSims.amigos().all({unAmigo => unAmigo.trabajo() == unSims.trabajo()})){
			unSims.aumentarFelicidad(unSims.nivelDeFelicidad()*0.1)
		}
	}
}

object copado inherits Trabajar{
	 method trabajar(unSims){
	 	self.porSerBuenazo(unSims)
	 	unSims.cambiarDinero(unSims.trabajo().plata())
	 	unSims.aumentarFelicidad(unSims.trabajo().unidadesFelicidad())
	 }
}	 

object mercenario inherits Trabajar {
	method trabajar(unSims){
		self.porSerBuenazo(unSims)
		unSims.cambiarDinero(100 + unSims.dinero()*0.02)
	}	
}	

object aburrido inherits Trabajar{
	method trabajar(unSims)
	{
		self.porSerBuenazo(unSims)
		unSims.cambiarDinero(unSims.trabajo().plata())
	 	unSims.disminuirFelicidad(unSims.trabajo().unidadesFelicidad())
	}
}
object desocupado{
	method trabajar(unSims, unTrabajo)
	{
	}
}

object sinPareja{
	method terminarRelacion(){}
	method ComenzarRelacion(){}
}
object hombre{}
object mujer{}
object soltero {}

object programador inherits Trabajo(20, 20, copado){}
object oficinista inherits Trabajo(20, 20, aburrido){}
object barraBrava inherits Trabajo(20, 20, mercenario){}

class Trabajo{
	var plataTrabajo
	var unidadesFelicidad
	var tipoTrabajo
	constructor(plata, felicidad, tipo){
		plataTrabajo = plata
		unidadesFelicidad = felicidad
		tipoTrabajo = tipo
	}
	method plata(){
		return plataTrabajo
	}
	method unidadesFelicidad(){
		return unidadesFelicidad
	}
	method tipoTrabajo(){
		return tipoTrabajo
	}
}
object celosPorPopularidad inherits Celos{
	method hacerQueTengaCelos(unSims)
	{
		self.bajarFelicidad(unSims)
		var nuevosAmigos = unSims.amigos().filter({unAmigo => unAmigo.popularidad() <= unSims.popularidad()})
		unSims.cambiarAmigos(nuevosAmigos)
		
	}
}
object celosPorPareja inherits Celos{
	method hacerQueTengaCelos(unSims)
	{
		self.bajarFelicidad(unSims)
		var nuevosAmigos = unSims.amigos().filter({unAmigo => not((unSims.pareja()).esAmigo(unAmigo))})
		unSims.cambiarAmigos(nuevosAmigos)
	}
}
object celosPorPlata inherits Celos{
	method hacerQueTengaCelos(unSims)
	{
		self.bajarFelicidad(unSims)
		var nuevosAmigos = unSims.amigos().filter({unAmigo => unAmigo.dinero() <= unSims.dinero()})
		unSims.cambiarAmigos(nuevosAmigos)
	}
}

class Celos{
	method bajarFelicidad(unSims){
		unSims.disminuirFelicidad(10)
	}
	
}
object normalidad{
	method nivelDeFelicidad(felicidad){
		return felicidad
	}
	method informacion(informacion){
		return informacion
	}
}

object soniador{
	method nivelDeFelicidad(felicidad){
		return felicidad + 1000
	}
	method informacion(informacion){
		return []
	}
}

object incomodidad{
	method nivelDeFelicidad(felicidad){
		return felicidad -200
	}
	method informacion(informacion){
		return informacion
	}
}
