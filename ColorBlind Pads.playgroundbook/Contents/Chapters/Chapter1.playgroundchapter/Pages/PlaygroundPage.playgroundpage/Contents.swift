/*:
 ## Welcome
 
 Products that were developed by Apple are used around the World by million of Artists. There are a lot of developers want to help Artists and make their creative process easier. Many Artists themselves are developers.
 
 I remember that I was really inspired when Gorillaz recorded their "The Fall" **just on iPad**. This was in 2010, but even then more than 20 apps were used in recording. Nowadays abundance of apps available in AppStore to make a melody, beat, record voice, etc.
 
 Unfortunately, I'm not a musician, but I like to play with samples on the iPad.
 
 - Experiment:
 Here you can set pads with some sounds and try to make your melody.
 Put the same color for a similar type of sound to easy recall during a session.
 */
//#-hidden-code
import Foundation
//#-code-completion(everything, hide)
//#-code-completion(chapterauxiliarymodule, show)
//#-code-completion(literal, show, boolean)
//#-code-completion(identifier, show, .kick1, .chant1, .hihat1)
//#-end-hidden-code
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
/*:
 ## Record
 
 You also can record your personal sample using a mic.
 Change `inEditMode` to `true` and keep touch on the pad for recording.
 
 - Important:
Don't forget to change the sound on a selected pad to `.customRecord`.
When you finish all records change `inEditMode` back to `false`.
 */
let inEditMode = /*#-editable-code*/false/*#-end-editable-code*/

//#-hidden-code
sendValue(.boolean(inEditMode))
do {
    let data = try JSONEncoder().encode(pads)
    sendValue(.data(data))
} catch let error {
    print("\(error) Unable to send the message")
}
//#-end-hidden-code
