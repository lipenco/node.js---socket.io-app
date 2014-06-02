Storage::setObj = (key, obj) ->
 localStorage.setItem key, JSON.stringify(obj)
Storage::getObj = (key) ->
 JSON.parse this.getItem(key)

class TodoApp
  constructor: ->
   @cacheElements()
   @bindEvents()
   @displayItems()

  cacheElements: ->
   @$input = $('#new-todo')
   @$todoList = $('#todo-list')
   @$clearCompleted = $('#clear-completed')
   @$joinListName = $("#join-list-name")
   @$join = $('#join')

  bindEvents: ->
   @$input.on 'keyup', (e) => @create e
   @$todoList.on 'click', '.destroy', (e) => @destroy e.target
   @$todoList.on 'change', '.toggle', (e) => @toggle e.target
   @$clearCompleted.on 'click', (e) => @clearCompleted()
   @$join.on 'click', (e) => @joinList()


  create: (e) ->
   val = $.trim @$input.val()
   return unless e.which == 13 and val
   randomId = Math.floor Math.random()*999999
   localStorage.setObj randomId,{
   id: randomId
   title: val
   completed: false
   }
   @$input.val ''
   @displayItems()

  displayItems: ->
   @clearItems()
   @addItem(localStorage.getObj(id)) for id in Object.keys(localStorage)

  clearItems: ->
   @$todoList.empty()


  addItem: (item) ->
    html = """
      <li #{if item.completed then 'class="completed"' else ''} data-id="#{item.id}">
      <div class="view">
        <input class="toggle" type="checkbox" #{if item.completed then 'checked' else ''}>
          <label>#{item.title}</label>
          <button class="destroy"></button>
            </div>
        </li>
         """
    @$todoList.append html


   destroy: (elem) ->
     id = ($(elem).closest 'li').data('id')
     localStorage.removeItem id
     @displayItems()
   toggle: (elem) ->
     id = $(elem).closest('li').data('id')
     item = localStorage.getObj(id)
     item.completed = !item.completed
     localStorage.setObj(id, item)

   clearCompleted: ->
     (localStorage.removeItem id for id in Object.keys(localStorage) \
     when (localStorage.getObj id).completed)
     @displayItems()

     joinList: ->
      @socket = io.connect('http://localhost:3000')
      @socket.on 'connect', =>
      @socket.emit 'joinList', @$joinListName.val()



$ ->
  app = new TodoApp()
