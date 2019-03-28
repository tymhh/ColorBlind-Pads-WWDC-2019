/*:
 ## Color
 Color Blindness is attributed to a congenital alteration constituting a visual insufficiency that disables the capacity of distinguishing several colors.
 Color blindness affects approximately every 1 in 12 men (8%) and 1 in 200 women (0.5%).
 
 There are many people who think the colorblind can’t see any color. But the term is misleading, more than 99% of all colorblind people can see color. However, they do have limited ability to distinguish between colors, especially in shades of a certain color. Something might look green, but in certain situations, it could also look red or blue.

 - Experiment:
 Change `colorBlindType` variable and **Run My Code** to apply a filter that simulates some type of colorblindness. Is it still easy to recognize color without literal explanation?
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, none, deuteranomaly, deuteranopia, protanomaly, protanopia, tritanomaly, tritanopia, achromatomaly, achromatopsia)
let colorBlindType: ColorBlindType = /*#-editable-code*/.none/*#-end-editable-code*/

//#-hidden-code
sendValue(.string(colorBlindType.rawValue))
//#-end-hidden-code
/*:
A friend of mine Francesco has `tritanomaly` type and for him, I made this solution. Go to [next page](@next)  to check in what way. */
