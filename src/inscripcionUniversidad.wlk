
//	CARRERA

class Carrera {
	
	const materias = []
	
	method materiasPorAnio(anio){
		if ( anio < 1 ) { // TODO En realidad esta validación es innecesaria.
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
	var property carrera = null
	var property materiasCorrelativas = null
	var property creditos = null
	var property anio = null
	var property cupo = null
	
	method estudiantesInscriptos() {
		return estudiantesInscriptos	
	}
	
	method listaDeEspera() {
		return estudiantesEnEspera
	}
	
	method correlativasAprobadas(estudiante) {
		return materiasCorrelativas.all (
			// TODO Delegar en estudiante.
			{ materia => estudiante.materiasAprobadas().contains(materia) }
		)
	}
	
	method cursandoMismoAnio(estudiante) {
		// TODO Esto no refleja lo que pide el enunciado
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

	var property materiasAprobadas = []
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
		// TODO Esto es una gran confusión, básicamente no tiene sentido
		return self.materiasAprobadasPorAnio(anioAnteriorMateria).all (
			{ materiaAprobada => carreraDeLaMateria.materiasPorAnio(anioAnteriorMateria)
				.contains(materiaAprobada)
			}
		)
	}
	
	method puedeInscribirse(materia) {
		return not materia.estaInscripto(self) and
				not materiasAprobadas.contains(materia) and
				// TODO Esta regla no corresponde al enunciado.
				self.anioAnteriorAprobado(materia)
	}
	
	method materiasAprobadasPorAnio(anio) {
		return materiasAprobadas.map (
			{ materia => materia.anio() == anio }
		)
	}
	
	// TODO Acá esto también es muy confuso, no parece tener sentido, nunca se usa.
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
	
	// TODO Este nombre no es muy descriptivo.
	method guaDelEstudiante(carrera) {
		const materiasDeCarrera = carrera.materiasTotales()
		return materiasDeCarrera.any (
			{ materia => self.puedeInscribirse(materia)}
		)
	}
	
	method InscripcioneTotales() {
		// TODO Esto devuelve una lista de carreras, no es lo pedido
		return carrerasCursando.filter (
			{ carrera => carrera.materiasTotales().estaInscrito(self)}
		)
	}
	
	method InscripcioneTotalesEnEspera() {
		// TODO Esto devuelve una lista de carreras, no es lo pedido
		return carrerasCursando.filter (
			{ carrera => carrera.materiasTotales().estaInscrito(self)}
		)
	}
}
	










