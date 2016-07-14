(in-package  #:react-examples/jquery-mobile)


(defmacro def-component-with-factory (name &body props)
  `(progn
     (defvar ,name
       (chain React (createClass (create ,@props))))
     (setf ,name (chain React (createFactory ,name)))))


(def-component-with-factory App
  displayName "App"

  render
  (lambda ()
    (chain React DOM (div (create className "app")
                          (JQueryMobilePage (create id "one") (PageOneContent nil))
                          (JQueryMobilePage (create id "two") (PageTwoContent nil))
                          (JQueryMobilePage (create id "popup" headerTheme "b") (PagePopUpContent nil))))))


(def-component-with-factory JQueryMobileButton
  displayName "JQueryMobileButton"

  getDefaultProps
  (lambda ()
    (create className "ui-btn ui-shadow ui-corner-all"))

  render
  (lambda ()
    (chain React DOM
           (p nil (chain React DOM
                         (a (@ this props) (@ this props children)))))))


(def-component-with-factory JQueryMobileContent
  displayName "JQueryMobileContent"

  render
  (lambda ()
    (chain React DOM (div (create role "main" className "ui-content")
                          (@ this props children)))))


(def-component-with-factory JQueryMobileFooter
  displayName "JQueryMobileFooter"

  render
  (lambda ()
    (chain React DOM
           (div (create :data-role "footer")
                (chain React DOM (h4 nil "Page footer"))))))


(def-component-with-factory JQueryMobileHeader
  displayName "JQueryMobileHeader"

  render
  (lambda ()
    (chain React DOM (div (create :data-role "header" :data-theme (@ this props headerTheme))
                          (chain React DOM (h1 nil (@ this props title)))))))


(def-component-with-factory JQueryMobilePage
  displayName "JQueryMobilePage"

  getDefaultProps
  (lambda ()
    (create :data-role "page" :data-theme "a" headerTheme "a"))

  render
  (lambda ()
    (let ((props (create)))
      (for-in (key (@ this props))
        (setf (getprop props key) (getprop (@ this props) key)))
      (chain React DOM
             (div props
                  (JQueryMobileHeader
                    (create
                      title (+ "Page " (@ this props id))
                      headerTheme (@ this props headerTheme)))
                  (JQueryMobileContent nil (@ this props children))
                  (JQueryMobileFooter nil))))))


(def-component-with-factory PageOneContent
  displayName "PageOneContent"

  render
  (lambda ()
    (chain React DOM
           (div nil
                (chain React DOM (h2 nil "One"))
                (chain React DOM
                       (p nil
                          "I have an "
                          (chain React DOM (code nil "id"))
                          " of \"one\" on my page container. I'm first in the source order so I'm shown when the page loads."))
                (chain React DOM
                       (p nil "This is a multi-page boilerplate template that you can copy to build your first jQuery Mobile page. This template contains multiple \"page\" containers inside, unlike a single page template that has just one page within it."))
                (chain React DOM
                       (p nil "Just view the source and copy the code to get started. All the CSS and JS is linked to the jQuery CDN versions so this is super easy to set up. Remember to include a meta viewport tag in the head to set the zoom level."))
                (chain React DOM
                       (p nil
                          "You link to internal pages by referring to the "
                          (chain React DOM (code nil "id"))
                          " of the page you want to show. For example, to "
                          (chain React DOM (a (create href "#two") "link"))
                          " to the page with an "
                          (chain React DOM (code nil "id"))
                          " of \"two\", my link would have a "
                          (chain React DOM (code nil "href=\"#two\""))
                          " in the code."))
                (chain React DOM
                       (h3 nil "Show internal pages:"))
                (JQueryMobileButton (create href "#two") "Show page \"two\"")
                (JQueryMobileButton (create href "#popup" :data-rel "dialog" :data-transition "pop")
                                    "Show page \"popup\" (as a dialog)")))))


(def-component-with-factory PageTwoContent
  displayName "PageTwoContent"
  
  render
  (lambda ()
    (chain React DOM
           (div nil
                (chain React DOM
                       (h2 nil "Two"))
                (chain React DOM
                       (p nil "I have an id of \"two\" on my page container. I'm the second page container in this multi-page template."))
                (chain React DOM
                       (p nil
                          "Notice that the theme is different for this page because we've added a few "
                          (chain React DOM (code nil "data-theme"))
                          " swatch assigments here to show off how flexible it is. You can add any content or widget to these pages, but we're keeping these simple."
                          ))
                (JQueryMobileButton (create
                                      href "#one"
                                      :data-direction "reverse"
                                      className "ui-btn ui-shadow ui-corner-all ui-btn-b")
                                    "Back to page \"one\"")))))


(def-component-with-factory PagePopUpContent
  displayName "PagePopUpContent"

  render
  (lambda ()
    (chain React DOM
           (div nil
                (chain React DOM
                       (h2 nil "Popup"))
                (chain React DOM
                       (p nil
                          "I have an id of \"popup\" on my page container and only look like a dialog because the link to me had a "
                          (chain React DOM (code nil "data-rel=\"dialog\""))
                          " attribute which gives me this inset look and a "
                          (chain React DOM (code nil "data-transition=\"pop\""))
                          " attribute to change the transition to pop. Without this, I'd be styled as a normal page."))
                (JQueryMobileButton (create href "#one" :data-rel "back" className "ui-btn ui-shadow ui-corner-all ui-btn-inline ui-icon-back ui-btn-icon-left")
                                    "Back to page \"one\"")))))


(chain ReactDOM (render (App nil) (chain document (getElementById "content"))))
