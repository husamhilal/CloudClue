# CloudClue.blog by Husam Hilal

## Operation Commands

* install Hugo on Windows: 
  
  winget install Hugo.Hugo.Extended --force --scope machine

* run hugo server in production:
  
  hugo server -D --disableFastRender --environment production

  hugo server --renderToMemory

* updating modules:

  hugo mod get -u

* adding a module:

  hugo mod get github.com/module-provider/modulename

## Credit

https://themes.gohugo.io/themes/hugo-theme-tailwind/

https://github.com/tomowang/hugo-theme-tailwind

https://github.com/martignoni/hugo-notice

https://hugomods.com/analytics/microsoft-clarity/

https://tailwindcss.com/docs

## Future enhancements

* Add button to go to top of the page once user scroll down (reference: https://github.com/adityatelange/hugo-PaperMod)
* Make the table of content (toc) collapsible (reference: https://github.com/adityatelange/hugo-PaperMod)