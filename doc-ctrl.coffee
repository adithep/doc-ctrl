tem_view = {}

class @Ctl
  constructor: (@doc) ->
  tem_obj: ->
    ctl = @ctl_obj()
    if ctl and ctl.tem_ty_n
      a = DATA.findOne(_s_n: "templates", tem_ty_n: @ctl_obj().tem_ty_n)
      if a
        if @doc._s_n is "_ctl"
          return a
        else if @doc._s_n is "data" and a.doc_comp
          return DATA.findOne(_s_n: "templates", tem_ty_n: a.doc_comp)
  ctl_cla: ->
    if @doc._cid
      return LDATA.findOne(_id: @doc._cid)
  get_key_dis: (key) ->
    if key
      key_obj = DATA.findOne(_s_n: "keys", key_n: String(key))
      if key_obj
        return key_obj.key_dis
  get_img: () ->
    doc = @data_obj()
    if doc.img_uuid
      return "http://localhost:8080/static/img/#{doc.img_uuid}"
  def_tem: ->
    ctl = @ctl_obj()
    if ctl and ctl.tem_ty_n
      return DATA.findOne(_s_n:"def_tem", tem_ty_n: ctl.tem_ty_n)
  root_def_tem: ->
    return DATA.findOne(_s_n:"def_tem", tem_ty_n: "root")
  ctl_obj: ->
    if @doc._s_n is "_ctl"
      return DATA.findOne(_id: @doc._ctl_id)
    else if @doc._s_n is "data"
      return @ctl_cla().ctl_obj()
  data_obj: ->
    if @doc._s_n is "data"
      return DATA.findOne(_id: @doc._did)
  get_href: ->
    ctl = @ctl_obj()
    doc = @data_obj()
    cla = @ctl_cla()
    if ctl and ctl.data_href
      if doc[ctl.data_href]
        if doc[ctl.data_href] is "blank"
          return "/"
        else
          return "/#{doc[ctl.data_href]}"
    else if ctl and ctl.data_sub_href
      if doc[ctl.data_sub_href]
        cur = Session.get("current_path")
        if cur
          dish = cur.replace(/^\/|\/$/g, '')
          arr = dish.split("/")
          if arr.length is cla.doc.depth
            return "#{cur}/#{doc[ctl.data_sub_href]}"
          else
            arr.splice(cla.doc.depth, arr.length)
            dash = arr.join("/")
            return "/#{dash}/#{doc[ctl.data_sub_href]}"
  get_look: ->
    ctl = @ctl_obj()
    if ctl and ctl.look_n
      return tem.look_n
    else
      tem = @def_tem()
      if tem and tem.look_n
        return tem.look_n
      else
        def = @root_def_tem()
        if def and def.look_n
          return def.look_n
    return

  get_tem: ->
    ctl = @ctl_obj()
    if @doc._s_n is "_ctl"
      if Template[ctl.tem_ty_n]
        return Template[ctl.tem_ty_n]
    else if @doc._s_n is "data"
      if Template[ctl.tem_ty_n+"_c"]
        return Template[ctl.tem_ty_n+"_c"]
    return null


###
  tem_loop: (html, arr, top, href) ->
    n = 0
    jj = ""
    while n < arr.length
      mm = ""
      if arr[n].tem_comp
        if href and href.dis_key
          html = @tem_loop(html, arr[n].tem_comp, false, {dis_key: true})
        else
          html = @tem_loop(html, arr[n].tem_comp)
      if top
        if href and href.dat is true
          cla = "#{arr[n].class} {{get_evt}}"
        else
          cla = "#{arr[n].class} {{get_look}}"
      else
        cla = arr[n].class
      mm = """
        <#{arr[n].tag} class='#{cla}'>
          #{html}
        </#{arr[n].tag}>
      """
      if href and href.dis_key is true and html is "{{_sel_doc}}"
        mm = "<span class=key_dis>{{_sel_key}}</span>" + mm
      jj = jj + mm
      if top and href and href.href is true
        jj = "<a href='{{get_href}}'>#{jj}</a>"
      n++
    return jj
  tem_compile: ->
    tem = @tem_obj()
    ctl = @ctl_obj()
    if tem
      unless tem_view[tem.tem_ty_n]
        if @doc._s_n is "_ctl"
          html = "{{#each t_yield}}{{>_sel_spa}}{{/each}}"
        else if @doc._s_n is "data"
          html = "{{_sel_doc}}"
        if tem.tem_comp
          if @doc._s_n is "data"
            obj = {}
            obj.dat = true
            if ctl.data_href
              obj.href = true
            if ctl.dis_key_dis
              obj.dis_key = true
            html = @tem_loop(html, tem.tem_comp, true, obj)
          else
            html = @tem_loop(html, tem.tem_comp, true)
        if @doc._s_n is "data"
          html = "{{#each k_yield}}#{html}{{/each}}"
        html_func = SpacebarsCompiler.compile(html, {isTemplate: true})
        ff = eval(html_func)
        b = Template.__create__('_ctrl', ff)
        tem_view[tem.tem_ty_n] = b
      if tem_view[tem.tem_ty_n]
        unless @tem_init is true
          @tem_init = true
          return tem_view[tem.tem_ty_n]
        else
          console.log "else"
          return
    return null
###
