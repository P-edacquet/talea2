import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calc-temps-passe"
export default class extends Controller {
  static targets = ['debut', 'fin', 'pause', 'agent2', 'temps']
  connect() {
    console.log('Hello, Stimulus! TEMPS PASSE', this.element)
  }

  initialize() {
    this.calc()
  }

  calc(){
    if (this.debutTarget.value != "" && this.finTarget.value != "") {
      let debut = new Date(this.debutTarget.value)
      let fin = new Date(this.finTarget.value)
      let pause = this.pauseTarget.value * 60
      let temps = this.tempsTarget
      if (fin > debut) {
        let temps_passé = Math.abs(fin - debut) / (1000 * 60 * 60)
        let temps_pause = pause / 60
        let temps_total = temps_passé - temps_pause
        if (this.agent2Target.value != "") {
          temps_total = temps_total *2
        }
        temps.value = temps_total.toFixed(2)
        temps.classList.remove('!text-red-500')
        temps.classList.add('!text-green-500')
      }
      else {
        temps.value = -1
        temps.classList.add('!text-red-500')
        temps.classList.remove('!text-green-500')
      }
    }
  }
}
