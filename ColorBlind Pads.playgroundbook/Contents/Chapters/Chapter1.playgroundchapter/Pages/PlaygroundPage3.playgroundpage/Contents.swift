/*:
 ## Color Should Be for All!
[ColorADD](glossary://ColorADD) code is a color identification system, an innovative universal language that enables to include without discrimination more than 350 million color blind people all over the world!
 
 Representing the 3 Primary Colors - Blue, Yellow and Red, by symbols, through the universal “Color Addition Theory”, symbols can be combined, and all colors graphically identified. Black and White symbols appear to indicate the Dark and Light tones of each color.
 
 ![Color Addition](ColorADD_Logo_sticker.png)
 
 The ColorADD project was presented in several national and worldwide events, also it won a lot of awards among which “Vodafone Mobile Awards” in the Accessibility Category. I'm really excited to collaborate with them.

 - Experiment:
 Symbols can help recognize color with any type of colorblindness types.
 You can apply each of them with different colors.
 Just play around with it and get a feeling of how it is to have a color vision handicap.
 */
//#-code-completion(everything, hide)
//#-code-completion(bookauxiliarymodule, show)

//#-hidden-code
import Foundation
//#-end-hidden-code
let colorBlindType: ColorBlindType = /*#-editable-code*/.none/*#-end-editable-code*/

let pads = [
    Pad(sound: /*#-editable-code*/.kick1/*#-end-editable-code*/, color: /*#-editable-code*/.green/*#-end-editable-code*/),
    Pad(sound: /*#-editable-code*/.chant1/*#-end-editable-code*/, color: /*#-editable-code*/.red/*#-end-editable-code*/),
    Pad(sound: /*#-editable-code*/.hihat1/*#-end-editable-code*/, color: /*#-editable-code*/.orange/*#-end-editable-code*/),
    Pad(sound: /*#-editable-code*/.perc1/*#-end-editable-code*/, color: /*#-editable-code*/.lightPurple/*#-end-editable-code*/),
    Pad(sound: /*#-editable-code*/.kick2/*#-end-editable-code*/, color: /*#-editable-code*/.green/*#-end-editable-code*/),
    Pad(sound: /*#-editable-code*/.chant2/*#-end-editable-code*/, color: /*#-editable-code*/.red/*#-end-editable-code*/),
    Pad(sound: /*#-editable-code*/.hihat2/*#-end-editable-code*/, color: /*#-editable-code*/.orange/*#-end-editable-code*/),
    Pad(sound: /*#-editable-code*/.perc2/*#-end-editable-code*/, color: /*#-editable-code*/.lightPurple/*#-end-editable-code*/)
]
//#-hidden-code
sendValue(.string(colorBlindType.rawValue))
do {
    let data = try JSONEncoder().encode(pads)
    sendValue(.data(data))
} catch let error {
    print("\(error) Unable to send the message")
}
//#-end-hidden-code

/*:
 ## Acknowledgments
 
 * The sounds used to sample the instruments were downloaded from [Cymatics.fm](https://cymatics.fm/pages/free-download-vault), under a Creative Commons License.
 * The [ColorADD](http://www.coloradd.net/) code is provided for me with a pro-bono model for educational, distribution for free and in all associated communication supports.
 */
