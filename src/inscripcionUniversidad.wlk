
//	CARRERA

class Carrera {
	
	const materias = []
	
	method materiasPorAnio(anio){
		if ( anio < 1 ) {
			return []
		}
		else {
			return materias.filter (
				{ materia => materia.anio() == anio }
			)
		}
	}
	
	method materiasTotales() {
		return materias
	}
}

//	MATERIAS

class Materia {
	
	var estudiantesInscriptos = []
	var estudiantesEnEspera = []
	const property carrera = null
	const property materiasCorrelativas = null
	const property creditos = null
	const property anio = null
	const property cupo = null
	
	method estudiantesInscriptos() {
		return estudiantesInscriptos	
	}
	
	method listaDeEspera() {
		return estudiantesEnEspera
	}
	
	method correlativasAprobadas(estudiante) {
		return materiasCorrelativas.all (
			{ materia => estudiante.materiasAprobadas().contains(materia) }
		)
	}
	
	method cursandoMismoAnio(estudiante) {
		return anio == estudiante.anioCursando()
	}
	
	method inscribirEstudiante(estudiante) {
		if (estudiantesInscriptos.size() > cupo) {
			estudiantesEnEspera.add(estudiante)
		}
		else {
			estudiantesInscriptos.add(estudiante)
		}
	}
	
	method bajarInscripcion(estudiante) {
		if (estudiantesEnEspera.contains(estudiante)) {
			estudiantesEnEspera.remove(estudiante)
		}
		else if (estudiantesInscriptos.contains(estudiante)) {
			estudiantesInscriptos.remove(estudiante)
			if (not estudiantesEnEspera.isEmpty()) {
				estudiantesInscriptos.add(estudiantesEnEspera.first())
				estudiantesEnEspera.remove(estudiantesEnEspera.first())
			}
		}
	}	
	
	method estaInscripto(estudiante) {
		return estudiantesInscriptos.contains(estudiante)
	}
	
	method estaEnEspera(estudiante) {
		return estudiantesEnEspera.contains(estudiante)
	}
}


class MateriaConCorrelativas inherits Materia {
	
	 method cumpleRequisitos(estudiante) {
		return self.correlativasAprobadas(estudiante)	
	}
}

class MateriaMismoAnio inherits Materia {
	
	method cumpleRequisitos(estudiante) {
		return self.cursandoMismoAnio(estudiante)
	}
}

class MateriaSinPrerrequisitos inherits Materia {
	
	method cumpleRequisitos(estudiante) {
		return true
	}
	
}


class MateriaPorCredito inherits Materia {
	
	const credito = null
	
	method cumpleRequisitos(estudiante) {
		return estudiante.creditos() >= credito
	}	
	
}


//	MATERIAS APROBADAS

class MateriaAprobada {
	
	const property nota = null
	const property anio = null
	
}


//	ESTUDIANTES

class Estudiante {

	var property materiasAprobadas = null
	var property carrerasCursando = []
	var property anioCursando = 0
	var property creditos = 0
	
	method puedeCursar(materia) {	
		return self.esMateriaDeLaCarrera(materia) and
				materia.cumpleRequisitos(self) and
				self.puedeInscribirse(materia)	
	}
	
	method esMateriaDeLaCarrera(materia) {
		var carreraDeLaMateria = materia.carrera()
		return carrerasCursando.contains(carreraDeLaMateria)
	}
	
	method anioAnteriorAprobado(materia) {
		var carreraDeLaMateria = materia.carrera()
		var anioAnteriorMateria = materia.anio() - 1
		return self.materiasAprobadasPorAnio(anioAnteriorMateria).all (
			{ materiaAprobada => carreraDeLaMateria.materiasPorAnio(anioAnteriorMateria)
				.contains(materiaAprobada)
			}
		)
	}
	
	method puedeInscribirse(materia) {
		return not materia.estaInscripto(self) and
				not materiasAprobadas.contains(materia) and
				self.anioAnteriorAprobado(materia)
	}
	
	method materiasAprobadasPorAnio(anio) {
		return materiasAprobadas.map (
			{ materia => materia.anio() == anio }
		)
	}
	
	method materiaAprobada(materiaAprobada,nota,anio) {
		materiaAprobada.nota(nota)
		materiaAprobada.anio(anio)
		materiasAprobadas.add(materiaAprobada)
	}
	
	method inscribir(materia) {
		if (self.puedeInscribirse(materia)) {
			materia.inscribirEstudiante(self)
		}
	}
	
	method darDeBaja(materia) {
		materia.bajaInscripcion(self)
	}
	
	method guaDelEstudiante(carrera) {
		const materiasDeCarrera = carrera.materiasTotales()
		return materiasDeCarrera.any (
			{ materia => self.puedeInscribirse(materia)}
		)
	}
	
	method InscripcioneTotales() {
		return carrerasCursando.filter (
			{ carrera => carrera.materiasTotales().estaInscrito(self)}
		)
	}
	
	method InscripcioneTotalesEnEspera() {
		return carrerasCursando.filter (
			{ carrera => carrera.materiasTotales().estaInscrito(self)}
		)
	}
}
	










