import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-agent-service"
export default class extends Controller {
  static targets = ['role', 'service']

  initialize() {
    this.serviceTarget.style.display = 'none';
    this.change();
  }

  connect() {
    // console.log("Hello, toggle-agent!", this.element)
  }

  change() {
    var role = this.roleTarget;

    if (role.value == 'agent') {
      this.serviceTarget.style.display = 'block';
    } else {
      this.serviceTarget.style.display = 'none';
      this.serviceTarget.children[1].selectedIndex = 0;
      // console.log(this.serviceTarget.children[1].selectedIndex)
    }
  }
}
