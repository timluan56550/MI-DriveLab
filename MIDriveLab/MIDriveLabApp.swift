
import SwiftUI
import FirebaseAppCheck
//Database stuff #If checks if it is avaliable
#if canImport(FirebaseCore)
import FirebaseCore
#endif

@main
struct MIDriveLabApp: App {
    @StateObject private var authentication = AuthenticationState()
    @StateObject private var mentors = MentorStore()
    init() {
        #if DEBUG
        // Register the simulator's debug token in Firebase if App Check is enforced.
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        #endif
        #if canImport(FirebaseCore)
        FirebaseApp.configure()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authentication)
                .environmentObject(mentors)
        }
    }
}

// Original practice questions based on What Every Driver Must Know, October 2025.
// Page references use the handbook's printed page numbers, not PDF page numbers.
let handbookURL = URL(
    string: "https://www.michigan.gov/sos/resources/forms/what-every-driver-must-know"
)!
let lessons = [
    Lesson(
        id: "signs",
        icon: "stop.circle",
        title: "Signs & signals",
        summary: "Start with the language of the road.",
        introduction:
            "Signs and signals tell you when to stop, yield, and proceed. Check for other road users before moving.",
        questions: [
            RoadQuestion(
                id: "signs-stop",
                prompt: "What does a STOP sign require?",
                options: [
                    "Come to a complete stop", "Slow down only", "Continue if the road looks clear",
                ],
                correctAnswer: 0,
                explanation:
                    "Stop fully and check for traffic before proceeding. Slowing down alone is not enough.",
                source: "Chapter 4 · Right of way · p. 30"
            ),
            RoadQuestion(
                id: "signs-flashing-red",
                prompt: "How should you respond to a flashing red traffic light?",
                options: [
                    "Keep moving if no cars are nearby",
                    "Stop, then proceed when the road is clear",
                    "Wait for the light to become green",
                ],
                correctAnswer: 1,
                explanation:
                    "A flashing red signal requires a full stop. Continue only when traffic allows you to proceed safely.",
                source: "Chapter 5 · Flashing red light · p. 50"
            ),
            RoadQuestion(
                id: "signs-yellow-arrow",
                prompt: "What must you do before turning left on a flashing yellow arrow?",
                options: [
                    "Assume oncoming traffic is stopped",
                    "Turn immediately because you have priority",
                    "Wait for a safe gap and yield to people crossing",
                ],
                correctAnswer: 2,
                explanation:
                    "Oncoming traffic has a green light. Turn only with an adequate gap and after checking for pedestrians and bicyclists.",
                source: "Chapter 5 · Flashing yellow arrow · p. 50"
            ),
            RoadQuestion(
                id: "signs-yield",
                prompt: "What does an inverted triangular traffic sign require you to do?",
                options: [
                    "Come to a complete stop regardless of other vehicles",
                    "Slow down and yield the right of way to crossing traffic and pedestrians",
                    "Speed up to merge before crossing traffic arrives",
                ],
                correctAnswer: 1,
                explanation:
                    "A triangular sign means YIELD. Slow down and let vehicles or pedestrians crossing your path go by before proceeding.",
                source: "Chapter 5 · Traffic signs · pp. 41, 44"
            ),
            RoadQuestion(
                id: "signs-pennant",
                prompt: "What is indicated by a pennant-shaped yellow warning sign placed on the left side of the road?",
                options: [
                    "A school crossing zone ahead",
                    "The beginning of a no-passing zone",
                    "A sharp curve with a lower recommended speed",
                ],
                correctAnswer: 1,
                explanation:
                    "A pennant-shaped sign is posted on the left side of a two-lane road to mark the start of a no-passing zone.",
                source: "Chapter 5 · Traffic signs · p. 41"
            ),
            RoadQuestion(
                id: "signs-school-zone",
                prompt: "What does a fluorescent yellow-green, pentagon-shaped sign indicate?",
                options: [
                    "A hospital or medical facility",
                    "A highway rest area or state park entrance",
                    "A school zone or school pedestrian crossing ahead",
                ],
                correctAnswer: 2,
                explanation:
                    "Pentagon-shaped signs with fluorescent yellow-green coloring alert drivers to schools, school crossings, and pedestrians.",
                source: "Chapter 5 · Traffic sign colors · pp. 41–42"
            ),
            RoadQuestion(
                id: "signs-solid-double-yellow",
                prompt: "What do double solid yellow lines down the center of a two-lane roadway mean?",
                options: [
                    "Passing is prohibited in both directions",
                    "Passing is permitted during daylight hours only",
                    "Lane changes are allowed with a turn signal",
                ],
                correctAnswer: 0,
                explanation:
                    "Double solid yellow lines mean passing is prohibited for traffic traveling in both directions.",
                source: "Chapter 5 · Pavement markings · p. 47"
            ),
            RoadQuestion(
                id: "signs-flashing-yellow",
                prompt: "You are approaching an intersection with a flashing yellow light. How should you proceed?",
                options: [
                    "Stop completely and wait for the light to turn green",
                    "Drive carefully through the intersection while scanning for cross traffic",
                    "Make an immediate U-turn",
                ],
                correctAnswer: 1,
                explanation:
                    "A flashing yellow light warns drivers to proceed carefully through the intersection while scanning for vehicles and pedestrians.",
                source: "Safe Driving Knowledge Test · p. 70"
            ),
            RoadQuestion(
                id: "signs-white-broken",
                prompt: "What does a broken white line between traffic lanes indicate?",
                options: [
                    "Traffic moves in the same direction, and lane changes are permitted when safe",
                    "Opposing two-way traffic where passing is permitted",
                    "A designated lane reserved strictly for bicycles and mopeds",
                ],
                correctAnswer: 0,
                explanation:
                    "Broken white lines separate lanes of traffic traveling in the same direction and indicate that lane changes are allowed when safe.",
                source: "Chapter 5 · Pavement markings · p. 47"
            ),
        ]
    ),
    Lesson(
        id: "lefts",
        icon: "arrow.uturn.left",
        title: "Michigan lefts",
        summary: "Understand Michigan’s distinctive intersections.",
        introduction:
            "A Michigan Left replaces a direct left turn with a route through a median crossover. Follow the signs and lane markings for your approach.",
        questions: [
            RoadQuestion(
                id: "lefts-route",
                prompt: "At a Michigan Left intersection, how do you make an indirect left turn?",
                options: [
                    "Make a direct left through the intersection",
                    "Follow the signed route straight or right, then use a median crossover",
                    "Reverse through the intersection",
                ],
                correctAnswer: 1,
                explanation:
                    "Direct left turns are prohibited at these intersections. Depending on your approach, continue straight or turn right before using the designated crossover.",
                source: "Chapter 5 · Michigan Lefts · p. 48"
            ),
            RoadQuestion(
                id: "lefts-unmarked",
                prompt:
                    "A median crossover has no lane markings. How many turning lanes should you treat it as having?",
                options: [
                    "One lane", "Two lanes if two cars fit", "As many lanes as drivers can form",
                ],
                correctAnswer: 0,
                explanation:
                    "Treat an unmarked crossover as a single lane. Extra width may be needed by trucks and other large vehicles.",
                source: "Chapter 5 · Michigan Lefts · p. 48"
            ),
            RoadQuestion(
                id: "lefts-markings",
                prompt: "What indicates that a Michigan Left crossover supports two turning lanes?",
                options: [
                    "A wide paved area alone", "Another driver pulling alongside you",
                    "Lane markings such as arrows, ONLY lettering, and solid white lines",
                ],
                correctAnswer: 2,
                explanation:
                    "Use the pavement markings to identify a multi-lane crossover. Width alone does not establish a second lane.",
                source: "Chapter 5 · Michigan Lefts · p. 48"
            ),
            RoadQuestion(
                id: "lefts-crossroad-turn",
                prompt: "When turning left from a cross street onto a divided highway at a Michigan Left intersection, what is the correct route?",
                options: [
                    "Make a direct left turn through the center of the intersection",
                    "Turn right onto the highway, merge into the far-left lane, then make a U-turn at the median crossover",
                    "Cross directly to the opposite shoulder and make a U-turn in active traffic",
                ],
                correctAnswer: 1,
                explanation:
                    "Crossroad drivers turn right onto the divided highway, signal and move across into the far-left lane, and then use the median crossover to head in their desired direction.",
                source: "Chapter 5 · Michigan Lefts · p. 48"
            ),
            RoadQuestion(
                id: "lefts-straight-turn",
                prompt: "If you are traveling on a highway with Michigan Left intersections and want to turn left onto an intersecting cross street, how do you proceed?",
                options: [
                    "Drive straight through the intersection, use the median crossover beyond it, and turn right onto the crossroad",
                    "Wait in the center of the intersection until oncoming traffic has a red light",
                    "Back into the median crossover from the right shoulder",
                ],
                correctAnswer: 0,
                explanation:
                    "Drive past the cross street intersection, enter the median crossover, make the U-turn when clear, and turn right onto the crossroad.",
                source: "Chapter 5 · Michigan Lefts · p. 48"
            ),
            RoadQuestion(
                id: "lefts-safety-benefit",
                prompt: "What is the primary safety purpose of Michigan Left intersections?",
                options: [
                    "To eliminate higher-speed travel on state trunklines",
                    "To eliminate dangerous direct left turns across oncoming traffic, reducing severe broadside crashes",
                    "To remove the need for traffic signals throughout the entire highway corridor",
                ],
                correctAnswer: 1,
                explanation:
                    "Michigan Lefts eliminate traditional left-turn movements across opposing high-speed lanes, significantly reducing severe angle and broadside collisions.",
                source: "Chapter 5 · Michigan Lefts · p. 48"
            ),
            RoadQuestion(
                id: "lefts-crossover-width",
                prompt: "Why are some single-lane Michigan Left crossovers paved wider than a standard traffic lane?",
                options: [
                    "To allow two passenger cars to turn side-by-side whenever traffic queues up",
                    "To accommodate large trucks, buses, and RVs that require a wider turning radius",
                    "To provide space for temporary vehicle parking and maintenance",
                ],
                correctAnswer: 1,
                explanation:
                    "The extra width in a single-lane crossover is designed to provide clearance for tractor-trailers and large recreational vehicles, not for multiple vehicles to line up side-by-side.",
                source: "Chapter 5 · Michigan Lefts · p. 48"
            ),
            RoadQuestion(
                id: "lefts-signalized-crossover",
                prompt: "If a Michigan Left median crossover is controlled by its own traffic signal showing a solid red light, what must you do?",
                options: [
                    "Stop, and do not turn until the signal gives a green indication or arrow",
                    "Proceed after a brief pause if cross traffic looks clear",
                    "Treat the red crossover light as an automatic yield sign",
                ],
                correctAnswer: 0,
                explanation:
                    "When a median crossover is signalized, you must obey the traffic signal and stop completely on red until the green signal or arrow allows you to proceed.",
                source: "Chapter 5 · Michigan Lefts · p. 48"
            ),
        ]
    ),
    Lesson(
        id: "winter",
        icon: "snowflake",
        title: "Winter driving",
        summary: "Explore visibility, traction, and preparation.",
        introduction:
            "Snow and ice reduce traction and stopping power. Give yourself more time and space, and make gradual changes in speed and direction.",
        questions: [
            RoadQuestion(
                id: "winter-space",
                prompt: "How should you adjust your driving when snow makes the road slippery?",
                options: [
                    "Keep your usual speed and follow more closely",
                    "Drive more slowly and increase following distance",
                    "Brake sharply before every turn",
                ],
                correctAnswer: 1,
                explanation:
                    "Slippery roads reduce stopping power. Slow down gradually and leave more room behind the vehicle ahead.",
                source: "Chapter 7 · Bad weather / Ice and snow · pp. 62–63"
            ),
            RoadQuestion(
                id: "winter-bridges",
                prompt: "Which areas can freeze before the rest of the road in cold weather?",
                options: [
                    "Only roads covered with deep snow", "Only roads without traffic",
                    "Bridges and underpasses",
                ],
                correctAnswer: 2,
                explanation:
                    "Watch for early freezing on bridges and underpasses, even when the surrounding road appears clear.",
                source: "Chapter 7 · Bad weather · p. 62"
            ),
            RoadQuestion(
                id: "winter-skid",
                prompt: "What should you do if your vehicle begins to skid?",
                options: [
                    "Ease off the accelerator and steer toward where you want to go",
                    "Accelerate hard to regain grip", "Turn the wheel as far as possible",
                ],
                correctAnswer: 0,
                explanation:
                    "Take your foot off the accelerator and turn the front wheels only enough to point in your intended direction. Be ready for a skid in the opposite direction.",
                source: "Chapter 7 · If your vehicle begins skidding · p. 63"
            ),
            RoadQuestion(
                id: "winter-black-ice",
                prompt: "What is 'black ice' and why is it especially hazardous?",
                options: [
                    "Thick slush mixed with road salt that slows vehicle acceleration",
                    "A thin, transparent coating of ice that blends in with dark pavement and looks like wet road",
                    "Hard-packed snow that only forms in sub-zero temperatures",
                ],
                correctAnswer: 1,
                explanation:
                    "Black ice is a transparent coating of clear ice on the roadway. It is difficult to spot because it looks like ordinary wet asphalt, giving drivers little warning of zero traction.",
                source: "Chapter 7 · Ice, snow and other slippery conditions · pp. 62–63"
            ),
            RoadQuestion(
                id: "winter-abs",
                prompt: "When performing an emergency stop on snow or ice in a vehicle equipped with Anti-Lock Brakes (ABS), what should you do?",
                options: [
                    "Pump the brake pedal vigorously up and down",
                    "Apply hard, steady pressure to the brake pedal and continue steering toward safety",
                    "Shift into neutral and apply the emergency handbrake",
                ],
                correctAnswer: 1,
                explanation:
                    "With ABS, press the brake pedal firmly and keep it pressed down. Do not pump the brakes. The system will pulse automatically while allowing you to steer.",
                source: "Chapter 7 · Braking · p. 63"
            ),
            RoadQuestion(
                id: "winter-standard-brakes",
                prompt: "If your vehicle has standard (non-ABS) brakes, how should you stop on a slippery winter road without losing steering control?",
                options: [
                    "Stomp on the brake pedal until the wheels lock completely",
                    "Apply steady pressure just short of locking the wheels; if they lock, release and reapply",
                    "Rely solely on downshifting without using the foot brake",
                ],
                correctAnswer: 1,
                explanation:
                    "In vehicles without ABS, use threshold or controlled braking: apply steady pressure just short of wheel lockup. If wheels lock, release briefly and reapply to maintain steering control.",
                source: "Chapter 7 · Braking · p. 63"
            ),
            RoadQuestion(
                id: "winter-clearing-snow",
                prompt: "Before driving after a winter snowstorm, what must you clear from your vehicle?",
                options: [
                    "Only a small viewing window on the windshield directly in front of the driver",
                    "Clear all snow and ice completely from all windows, mirrors, roof, hood, and light lenses",
                    "Nothing, as airflow at highway speeds will blow the snow away",
                ],
                correctAnswer: 1,
                explanation:
                    "Clear all snow and ice from all windows, mirrors, headlights, taillights, hood, and roof. Snow left on the roof can blow off and blind drivers behind you.",
                source: "Chapter 7 · Bad weather · p. 62"
            ),
            RoadQuestion(
                id: "winter-emergency-kit",
                prompt: "Which items are specifically recommended by Michigan's driver handbook for a winter vehicle emergency kit?",
                options: [
                    "A blanket, flashlight, booster cables, shovel, and sand or kitty litter for traction",
                    "Only an extra jug of windshield washer fluid",
                    "A portable gas canister and road flares stored inside the passenger cabin",
                ],
                correctAnswer: 0,
                explanation:
                    "Winter emergency supplies should include warm blankets, a flashlight, booster cables, a snow shovel, and abrasive material like sand or cat litter to help gain traction if stuck.",
                source: "Chapter 7 · Bad weather · p. 62"
            ),
        ]
    ),
    Lesson(
        id: "merge",
        icon: "arrow.triangle.merge",
        title: "Merging & roundabouts",
        summary: "Build confidence sharing the road.",
        introduction:
            "Merging safely means choosing a gap and yielding to traffic already on the road. At a roundabout, choose your lane before entering and watch for people crossing.",
        questions: [
            RoadQuestion(
                id: "merge-freeway",
                prompt: "What is the correct way to merge onto a freeway?",
                options: [
                    "Expect freeway drivers to stop for you",
                    "Enter without checking your blind spot",
                    "Use the acceleration lane, signal, check traffic, and yield as you merge",
                ],
                correctAnswer: 2,
                explanation:
                    "Use the acceleration lane to match freeway traffic speed. Check mirrors and over your shoulder, choose a safe gap, and yield to freeway traffic.",
                source: "Chapter 7 · Freeway driving · p. 61"
            ),
            RoadQuestion(
                id: "merge-yield",
                prompt: "Who has the right of way when you enter a roundabout?",
                options: [
                    "Vehicles already circulating, approaching from your left",
                    "The vehicle entering fastest", "Entering vehicles always go first",
                ],
                correctAnswer: 0,
                explanation:
                    "Yield to circulating traffic and watch for pedestrians and bicyclists. Enter only when there is a safe gap.",
                source: "Chapter 4 · Roundabouts · p. 35"
            ),
            RoadQuestion(
                id: "merge-exit",
                prompt: "What should you do if you miss your roundabout exit?",
                options: [
                    "Stop and reverse to the exit", "Continue around to reach your exit again",
                    "Cut across the center island",
                ],
                correctAnswer: 1,
                explanation:
                    "Keep moving slowly around the roundabout and take your exit on the next circuit. Signal your exit and watch for pedestrians.",
                source: "Chapter 4 · Roundabouts · p. 35"
            ),
            RoadQuestion(
                id: "merge-zipper",
                prompt: "In slow, heavy traffic where two lanes merge into one in a construction zone, how does Michigan encourage drivers to merge (the 'zipper merge')?",
                options: [
                    "Merge miles before the lane ends into a single standstill line",
                    "Use both open lanes until the merge point, then alternate taking turns like teeth on a zipper",
                    "Drive along the shoulder to pass waiting vehicles",
                ],
                correctAnswer: 1,
                explanation:
                    "In congested work zone traffic, the zipper merge directs drivers to utilize both lanes right up to the lane closure point, then take alternating turns merging smoothly.",
                source: "Chapter 4 · Merging in a construction zone · p. 27"
            ),
            RoadQuestion(
                id: "merge-deceleration-lane",
                prompt: "When exiting a freeway via an off-ramp, when should you start slowing down?",
                options: [
                    "Slow down significantly in the right highway lane before entering the exit ramp",
                    "Maintain speed until your vehicle has fully entered the deceleration lane, then slow down smoothly",
                    "Coast in neutral while still in the freeway lane",
                ],
                correctAnswer: 1,
                explanation:
                    "Do not slow down on the freeway mainline. Enter the deceleration lane at highway speed, then brake smoothly to reach the advisory speed posted for the ramp.",
                source: "Chapter 7 · Leaving a freeway · p. 61"
            ),
            RoadQuestion(
                id: "merge-roundabout-lane-choice",
                prompt: "When approaching a multi-lane roundabout, when must you choose your travel lane?",
                options: [
                    "Before entering the roundabout, using posted guide signs and pavement arrows",
                    "After entering the circular roadway by switching lanes inside",
                    "Lane choice does not matter in roundabouts",
                ],
                correctAnswer: 0,
                explanation:
                    "Choose your lane before entering the roundabout based on lane markings and overhead signs. Do not change lanes once you are circulating inside.",
                source: "Chapter 4 · Roundabouts · p. 35"
            ),
            RoadQuestion(
                id: "merge-roundabout-pedestrians",
                prompt: "Who has the right of way at pedestrian crosswalks situated at roundabout entries and exits?",
                options: [
                    "Vehicles entering the roundabout have the right of way",
                    "Pedestrians in the crosswalk always have the right of way",
                    "The fastest moving vehicle",
                ],
                correctAnswer: 1,
                explanation:
                    "Always yield to pedestrians crossing at crosswalks on both the entry and exit legs of a roundabout.",
                source: "Chapter 4 · Roundabouts · p. 35"
            ),
            RoadQuestion(
                id: "merge-courtesy-move",
                prompt: "You are driving in the right lane of a freeway. Traffic is light, and cars are entering from an on-ramp ahead. What is good defensive driving?",
                options: [
                    "Speed up to pass before the entering vehicles reach the merge point",
                    "Move over to the left lane if traffic allows, providing merging traffic a clear opening",
                    "Honk repeatedly to warn entering drivers to stay back",
                ],
                correctAnswer: 1,
                explanation:
                    "When traffic is light, courteously moving over to the adjacent left lane allows merging traffic to enter the freeway smoothly and safely.",
                source: "Safe Driving Knowledge Test · p. 69"
            ),
        ]
    ),
    Lesson(
        id: "rightofway",
        icon: "arrow.triangle.branch",
        title: "Right of way & intersections",
        summary: "Know when to yield and who goes first.",
        introduction:
            "Right-of-way rules prevent collisions at intersections, crosswalks, bus stops, and railroad tracks. When in doubt, yield.",
        questions: [
            RoadQuestion(
                id: "row-4way-first",
                prompt: "At a 4-way stop intersection, which driver has the right of way?",
                options: [
                    "The driver who arrived and came to a complete stop first",
                    "The driver in the largest or heaviest vehicle",
                    "The driver traveling on the wider street",
                ],
                correctAnswer: 0,
                explanation:
                    "At a four-way stop, the vehicle that reaches the intersection and stops first has the right of way to proceed.",
                source: "Chapter 4 · Right of way at intersections · p. 30"
            ),
            RoadQuestion(
                id: "row-4way-tie",
                prompt: "If two vehicles stop at a 4-way stop intersection at the exact same moment, who must yield?",
                options: [
                    "The vehicle on the left must yield to the vehicle on its right",
                    "The vehicle on the right must yield to the vehicle on its left",
                    "The vehicle turning left goes first",
                ],
                correctAnswer: 0,
                explanation:
                    "When two vehicles arrive and stop simultaneously, the driver on the left must yield the right of way to the vehicle on the right.",
                source: "Chapter 4 · Right of way at intersections · p. 30"
            ),
            RoadQuestion(
                id: "row-schoolbus-red",
                prompt: "When a school bus stops on an undivided road with its overhead RED lights flashing, how far away must motorists stop?",
                options: [
                    "At least 10 feet",
                    "At least 20 feet",
                    "At least 50 feet",
                ],
                correctAnswer: 1,
                explanation:
                    "Michigan law requires drivers in all directions on undivided roads to stop at least 20 feet from a school bus displaying flashing red overhead lights.",
                source: "Chapter 4 · School buses · pp. 28–29"
            ),
            RoadQuestion(
                id: "row-schoolbus-divided",
                prompt: "When a school bus stops with overhead red lights flashing on the other side of a divided highway separated by a concrete barrier or median, what should you do?",
                options: [
                    "Stop at least 20 feet away just like vehicles on the bus side",
                    "You are not required to stop; continue driving with caution",
                    "Stop and wait for the bus driver to wave you through",
                ],
                correctAnswer: 1,
                explanation:
                    "Motorists traveling on the opposite side of a divided highway with a physical barrier (such as a concrete wall or grass median) are not required to stop for a school bus.",
                source: "Chapter 4 · School buses · pp. 28–29"
            ),
            RoadQuestion(
                id: "row-move-over",
                prompt: "Under Michigan's Move Over Law, what must you do when approaching a stationary emergency or maintenance vehicle with flashing lights on the roadside?",
                options: [
                    "Maintain your speed and honk to acknowledge the vehicle",
                    "Slow down at least 10 mph below the posted speed limit and move over at least one lane if safe",
                    "Come to a complete stop in your travel lane",
                ],
                correctAnswer: 1,
                explanation:
                    "Michigan's Move Over Law requires drivers to slow down at least 10 mph below the speed limit and vacate the lane adjacent to the emergency or maintenance vehicle if safe to do so.",
                source: "Chapter 4 · Emergency vehicles · p. 28"
            ),
            RoadQuestion(
                id: "row-funeral-procession",
                prompt: "What right-of-way rule applies to an authorized funeral procession displaying official fluorescent orange flags?",
                options: [
                    "Procession vehicles must stop and yield at every intersection",
                    "The procession has the right of way over all vehicles except emergency vehicles responding to calls",
                    "Motorists may cut through gaps between vehicles in the procession",
                ],
                correctAnswer: 1,
                explanation:
                    "Funeral processions displaying designated flags have right of way over all other vehicles, except emergency vehicles. Cutting through a funeral procession is a civil infraction.",
                source: "Chapter 4 · Right of way and funerals · p. 31"
            ),
            RoadQuestion(
                id: "row-left-on-red",
                prompt: "In Michigan, when is a left turn on a red signal legally permitted?",
                options: [
                    "Never; left turns on red are always prohibited in Michigan",
                    "When turning from a one-way or two-way street onto a one-way street carrying traffic in that direction, after a complete stop and yield",
                    "Only between 10:00 p.m. and 5:00 a.m. at low-traffic intersections",
                ],
                correctAnswer: 1,
                explanation:
                    "In Michigan, left turns on red are permitted from a one-way or two-way street onto a one-way street in the direction of traffic flow, after stopping completely and yielding, unless a sign states otherwise.",
                source: "Chapter 4 · Right of way when turning · pp. 29–30"
            ),
            RoadQuestion(
                id: "row-railroad-stuck",
                prompt: "If your car stalls on railroad tracks with no train approaching and gates not activated, what is the first priority?",
                options: [
                    "Stay inside and keep cranking the ignition key",
                    "Get everyone out of the vehicle and away from the tracks immediately, then call the number on the blue ENS sign",
                    "Try pushing the car off the tracks by yourself",
                ],
                correctAnswer: 1,
                explanation:
                    "Immediately get everyone out and away from the tracks. Call the railroad emergency phone number on the blue Emergency Notification System (ENS) sign with the crossing DOT ID.",
                source: "Chapter 4 · If you are stuck on the tracks · pp. 36–37"
            ),
            RoadQuestion(
                id: "row-signal-malfunction",
                prompt: "If an intersection's traffic signal is completely dark or non-functioning with no officer present, how must drivers treat it?",
                options: [
                    "As an uncontrolled intersection where the fastest traffic goes first",
                    "As an all-way stop: come to a complete stop and yield to vehicles already there or to your right",
                    "Proceed through without stopping if the through road is wider",
                ],
                correctAnswer: 1,
                explanation:
                    "A non-working traffic signal must be treated as an all-way stop. Stop completely, yield to traffic already in the intersection, and yield to the driver on your right if arriving together.",
                source: "Chapter 5 · Traffic signals · p. 49"
            ),
        ]
    ),
    Lesson(
        id: "sharing",
        icon: "bus.fill",
        title: "Sharing the road",
        summary: "Safely coexist with trucks, bikes, and pedestrians.",
        introduction:
            "Large trucks take longer to stop, and bicyclists and motorcyclists have less protection. Give vulnerable road users room and respect.",
        questions: [
            RoadQuestion(
                id: "share-truck-no-zones",
                prompt: "What are the 'No-Zones' around large commercial trucks and buses?",
                options: [
                    "Lanes where commercial vehicles are prohibited by law",
                    "Large blind spots directly in front, directly behind, and along both sides where the driver cannot see you",
                    "Designated weigh station inspection areas",
                ],
                correctAnswer: 1,
                explanation:
                    "No-Zones are the extensive blind spots around the front, rear, and sides of commercial vehicles. If you cannot see the driver in their side mirrors, they cannot see you.",
                source: "Chapter 6 · Commercial vehicles · p. 53"
            ),
            RoadQuestion(
                id: "share-truck-stop-dist",
                prompt: "At 55 mph, while an average passenger car can stop in about 130 feet, about how much distance does a commercial truck need to stop?",
                options: [
                    "About 150 feet",
                    "About 250 feet",
                    "About 400 feet",
                ],
                correctAnswer: 2,
                explanation:
                    "Due to massive weight and air brake lag, a commercial vehicle traveling at 55 mph requires roughly 400 feet to stop — more than three times the distance of a car.",
                source: "Chapter 6 · Commercial vehicles · p. 53"
            ),
            RoadQuestion(
                id: "share-truck-wide-right",
                prompt: "When a semi-truck approaches an intersection with its right-turn signal on, why might it swing out into the left lane first?",
                options: [
                    "The driver changed their mind and is turning left",
                    "Large trucks need a wider turning radius to prevent the trailer from running over the curb",
                    "The truck is signaling for you to pass on its right side",
                ],
                correctAnswer: 1,
                explanation:
                    "Semi-trailers off-track and cut corners. Trucks must often swing wide left before making a right turn.  Never try to squeeze between a turning truck and the curb.",
                source: "Chapter 6 · Commercial vehicles · p. 53"
            ),
            RoadQuestion(
                id: "share-bike-clearance",
                prompt: "Under Michigan law, what is the minimum distance a driver must leave when passing a bicyclist?",
                options: [
                    "At least 3 feet of space",
                    "At least 1 foot of space",
                    "No specific distance as long as you do not collide",
                ],
                correctAnswer: 0,
                explanation:
                    "Michigan state law requires motorists to leave at least 3 feet of clearance when passing a bicyclist. Some local municipalities require 5 feet.",
                source: "Chapter 6 · Bicyclists · p. 57"
            ),
            RoadQuestion(
                id: "share-motorcycle-lane",
                prompt: "May a passenger car drive alongside or pass a motorcycle in the same lane?",
                options: [
                    "Yes, if the lane is wide enough for both vehicles",
                    "No, motorcyclists are legally entitled to the full width of the lane",
                    "Yes, but only in heavy stop-and-go city traffic",
                ],
                correctAnswer: 1,
                explanation:
                    "It is illegal for motorists to drive beside or pass a motorcycle in the same lane. Motorcyclists are legally entitled to the complete width of the lane.",
                source: "Chapter 6 · Specifically about motorcyclists · p. 56"
            ),
            RoadQuestion(
                id: "share-slow-moving-emblem",
                prompt: "What does an orange reflective triangular emblem mounted on the rear of a vehicle signify?",
                options: [
                    "A vehicle carrying explosive hazardous materials",
                    "A slow-moving vehicle traveling at 25 mph or less",
                    "A student driver vehicle",
                ],
                correctAnswer: 1,
                explanation:
                    "The orange reflective triangle denotes a slow-moving vehicle, such as farm equipment or Amish buggies, designed to travel at 25 mph or slower.",
                source: "Chapter 6 · Slow-moving vehicles · p. 54"
            ),
            RoadQuestion(
                id: "share-dutch-reach",
                prompt: "What is the recommended 'Dutch Reach' method when opening your car door after parking along a curb?",
                options: [
                    "Reach across and open the door with your right hand so your body turns to look over your shoulder for cyclists",
                    "Kick the door open quickly to clear any oncoming pedestrians",
                    "Leave the door partially cracked open for 30 seconds before exiting",
                ],
                correctAnswer: 0,
                explanation:
                    "Opening the driver-side door with your far hand (right hand) naturally rotates your torso, forcing you to look over your left shoulder for oncoming bicyclists and traffic.",
                source: "Chapter 4 & 6 · pp. 37, 56"
            ),
            RoadQuestion(
                id: "share-truck-rearview",
                prompt: "When passing a commercial truck on the highway, when is it safe to return to the truck's lane?",
                options: [
                    "As soon as your car's rear bumper clears the truck's front bumper",
                    "When you can clearly see the entire cab of the truck in your inside rearview mirror",
                    "Immediately after turning on your turn signal",
                ],
                correctAnswer: 1,
                explanation:
                    "Before pulling back in front of a passed commercial truck, make sure you can see the entire front cab of the truck in your inside rearview mirror.",
                source: "Chapter 6 · Passing a commercial vehicle safely · p. 54"
            ),
        ]
    ),
    Lesson(
        id: "speed",
        icon: "hand.raised.fill",
        title: "Speed & distracted driving",
        summary: "Master legal speed limits and phone laws.",
        introduction:
            "Speed limits set the legal boundary, but the Basic Speed Law demands driving to conditions. Distracted driving is strictly illegal in Michigan.",
        questions: [
            RoadQuestion(
                id: "speed-hands-free-law",
                prompt: "Under Michigan's hands-free mobile phone law, what is prohibited while operating a motor vehicle on public roads?",
                options: [
                    "Listening to music through your car's audio system",
                    "Holding or manually using a mobile phone or electronic device to call, text, or browse",
                    "Using a hands-free navigation system that is mounted to the dashboard",
                ],
                correctAnswer: 1,
                explanation:
                    "Michigan law prohibits holding or manually using a cell phone or electronic device while driving, including texting, scrolling, calling, or recording video.",
                source: "Chapter 4 · Cell phone use prohibited · p. 24"
            ),
            RoadQuestion(
                id: "speed-cell-emergency-ex",
                prompt: "When is a driver legally permitted to hold a mobile phone while driving on Michigan roads?",
                options: [
                    "When stopped at a red light or railroad crossing",
                    "To call or text 911 to report a medical emergency, traffic crash, crime, or serious road hazard",
                    "When answering an urgent call from work or school",
                ],
                correctAnswer: 1,
                explanation:
                    "Holding a phone while driving is permitted solely for emergency exceptions, such as calling 911 to report crashes, medical emergencies, crimes, or road hazards.",
                source: "Chapter 4 · Emergency exceptions · p. 24"
            ),
            RoadQuestion(
                id: "speed-basic-law",
                prompt: "What does Michigan's Basic Speed Law require of every motorist?",
                options: [
                    "Drive at the maximum posted limit under all circumstances",
                    "Drive at a careful and prudent speed that allows you to stop safely within the clear distance ahead",
                    "Always drive at least 10 mph below the posted limit when raining",
                ],
                correctAnswer: 1,
                explanation:
                    "The Basic Speed Law requires driving at a careful and prudent speed suited to current conditions, ensuring you can always stop within the assured clear distance ahead.",
                source: "Chapter 4 · Speed limits · p. 26"
            ),
            RoadQuestion(
                id: "speed-residence-limit",
                prompt: "Unless otherwise posted, what is the legal speed limit in Michigan residential subdivisions and condominium complexes?",
                options: [
                    "15 mph",
                    "25 mph",
                    "35 mph",
                ],
                correctAnswer: 1,
                explanation:
                    "Under Michigan law, the standard unposted speed limit in platted subdivisions and condominium complexes is 25 mph.",
                source: "Chapter 4 · Speed limits · p. 26"
            ),
            RoadQuestion(
                id: "speed-mobile-home-park",
                prompt: "What is the legal speed limit inside mobile home parks in Michigan?",
                options: [
                    "15 mph",
                    "20 mph",
                    "25 mph",
                ],
                correctAnswer: 0,
                explanation:
                    "The speed limit in mobile home parks and some municipal parks in Michigan is 15 mph.",
                source: "Chapter 4 · Speed limits · p. 26"
            ),
            RoadQuestion(
                id: "speed-freeway-limits",
                prompt: "On Michigan freeways without different posted limits, what are the standard maximum and minimum speeds for passenger vehicles?",
                options: [
                    "65 mph maximum / 45 mph minimum",
                    "70 mph maximum / 55 mph minimum",
                    "75 mph maximum / 60 mph minimum",
                ],
                correctAnswer: 1,
                explanation:
                    "Standard Michigan freeway speed limits for passenger vehicles are 70 mph maximum and 55 mph minimum, unless posted otherwise.",
                source: "Chapter 4 · Speed limits · p. 26"
            ),
            RoadQuestion(
                id: "speed-work-zone-penalties",
                prompt: "What special penalties apply to moving violations committed in designated highway work zones?",
                options: [
                    "Standard fines with no points assessed",
                    "Fines are doubled, and points posted to your driving record are increased",
                    "Automatic 30-day driver license suspension",
                ],
                correctAnswer: 1,
                explanation:
                    "In Michigan construction zones, moving violation fines are doubled, and speeding points are increased (3 points for up to 10 mph over, 4 for 11–15 over, 5 for 15+ over).",
                source: "Chapter 4 · Construction zones · p. 27"
            ),
            RoadQuestion(
                id: "speed-child-seats",
                prompt: "Under Michigan child passenger safety law, how should children younger than 2 years old be secured in a vehicle?",
                options: [
                    "In any forward-facing child safety seat",
                    "In a rear-facing child-restraint system in the rear seat of the vehicle",
                    "In a booster seat using the standard vehicle lap belt",
                ],
                correctAnswer: 1,
                explanation:
                    "Michigan law requires children under age 2 to be seated in a rear-facing child restraint in the rear seat until they outgrow manufacturer limits.",
                source: "Chapter 4 · Protecting children and teens · p. 25"
            ),
        ]
    ),
    Lesson(
        id: "emergencies",
        icon: "exclamationmark.triangle",
        title: "Emergencies & hazards",
        summary: "Handle night glare, deer, blowouts, and stops.",
        introduction:
            "From unexpected tire blowouts and deer crossings to night driving and traffic stops, prepared drivers react calmly and safely.",
        questions: [
            RoadQuestion(
                id: "emerg-deer-collision",
                prompt: "If a collision with a deer is unavoidable on a Michigan roadway, what is the safest course of action?",
                options: [
                    "Swerve sharply into the oncoming lane or shoulder to miss the deer",
                    "Brake firmly, hold the steering wheel straight, and stay in your lane",
                    "Accelerate quickly to minimize the impact point",
                ],
                correctAnswer: 1,
                explanation:
                    "Do not veer for deer! Swerving frequently leads to head-on collisions with oncoming traffic or rollovers into trees and ditches. Brake firmly and stay in your lane.",
                source: "Chapter 7 · Vehicle – deer crashes · p. 65"
            ),
            RoadQuestion(
                id: "emerg-headlight-hours",
                prompt: "When does Michigan law require headlights to be turned on?",
                options: [
                    "From sunset to sunrise only",
                    "From one half-hour after sunset until one half-hour before sunrise, and whenever visibility is reduced",
                    "Only when streetlights turn on",
                ],
                correctAnswer: 1,
                explanation:
                    "Michigan requires headlights on from one half-hour after sunset until one half-hour before sunrise, and anytime weather or visibility requires them.",
                source: "Chapter 7 · Driving at night · p. 64"
            ),
            RoadQuestion(
                id: "emerg-dimming-distance",
                prompt: "At what distances must you dim your high-beam headlights to low beams when driving at night?",
                options: [
                    "At least 500 feet before meeting oncoming vehicles, and 300 feet when following another vehicle",
                    "At least 200 feet for oncoming vehicles, and 100 feet when following",
                    "Only when prompted by headlights flashed by the other driver",
                ],
                correctAnswer: 0,
                explanation:
                    "Dim high beams to low beams within 500 feet of an oncoming vehicle and within 300 feet when following another vehicle from behind.",
                source: "Chapter 7 · Driving at night · p. 64"
            ),
            RoadQuestion(
                id: "emerg-headlight-glare",
                prompt: "To reduce the blinding effects of oncoming high-beam headlights at night, where should you direct your gaze?",
                options: [
                    "Straight ahead into the center of the road",
                    "Toward the right edge of the road or white lane line",
                    "Directly at the oncoming vehicle's headlights to gauge position",
                ],
                correctAnswer: 1,
                explanation:
                    "Look toward the right edge of the road or the painted fog line to avoid glare and keep your vehicle properly positioned in your lane.",
                source: "Safe Driving Knowledge Test · p. 70 / Chapter 7 · p. 64"
            ),
            RoadQuestion(
                id: "emerg-tire-blowout",
                prompt: "What should you do if one of your tires blows out while traveling at speed on the roadway?",
                options: [
                    "Slam on the brakes with maximum force immediately",
                    "Grip the steering wheel firmly, ease off the accelerator, and coast smoothly off the road",
                    "Steer back and forth to keep the tire inflated",
                ],
                correctAnswer: 1,
                explanation:
                    "Do not brake hard! Maintain a firm grip on the steering wheel to stay in your lane, release the accelerator gently, and pull off once your vehicle has slowed.",
                source: "Chapter 7 · Emergency situations · p. 64"
            ),
            RoadQuestion(
                id: "emerg-pulled-over",
                prompt: "If a police officer signals you to pull over, what is the correct safety procedure?",
                options: [
                    "Pull over safely to the right shoulder, keep your hands visible on the steering wheel, and await directions",
                    "Jump out of your vehicle immediately to explain what happened",
                    "Quickly reach into the glove compartment to retrieve your documents before the officer walks up",
                ],
                correctAnswer: 0,
                explanation:
                    "Pull over safely to the right, remain in your car with seat belts fastened, keep your hands in plain sight on the steering wheel, and wait for the officer's instructions.",
                source: "Chapter 7 · If you are pulled over · p. 67"
            ),
            RoadQuestion(
                id: "emerg-oncoming-car",
                prompt: "If an oncoming vehicle drifts into your lane heading directly toward you, what should you do?",
                options: [
                    "Swerve left into their oncoming lane to pass them",
                    "Honk your horn, brake, and steer toward the right shoulder or ditch",
                    "Lock your brakes and stay stopped in the center of the lane",
                ],
                correctAnswer: 1,
                explanation:
                    "Honk your horn, brake, and steer to the right shoulder. Never steer left into the oncoming lane, as the driver may suddenly correct back into their lane.",
                source: "Chapter 7 · If an oncoming vehicle is in your lane · p. 62"
            ),
            RoadQuestion(
                id: "emerg-thick-fog",
                prompt: "Which headlight setting should you use when driving through dense fog, rain, or snow?",
                options: [
                    "High beams to project light as far as possible",
                    "Low beams, because high beams reflect off moisture particles directly back into your eyes",
                    "Parking lights only",
                ],
                correctAnswer: 1,
                explanation:
                    "Always use low beams in fog, rain, or snow. High beams bounce off water droplets and snow particles, causing blinding reflective glare.",
                source: "Chapter 7 · Rain and fog · p. 62"
            ),
        ]
    ),
    Lesson(
        id: "licensing",
        icon: "person.text.rectangle",
        title: "Licensing & point system",
        summary: "Understand GDL tiers, points, and OWI laws.",
        introduction:
            "Driving is a privilege earned through Graduated Driver Licensing. Know how violations affect points and how Michigan enforces sober driving.",
        questions: [
            RoadQuestion(
                id: "lic-gdl-supervised-hours",
                prompt: "Under Michigan's GDL Level 1, how many total supervised practice driving hours (including night hours) are required before taking the Driving Skills Test?",
                options: [
                    "30 hours total, including 2 night hours",
                    "50 hours total, including at least 10 hours at night",
                    "100 hours total, including 20 night hours",
                ],
                correctAnswer: 1,
                explanation:
                    "Before taking the Driving Skills Test, teens must complete at least 50 hours of supervised driving, with a minimum of 10 hours at night.",
                source: "Chapter 1 · Driving skills test · p. 5"
            ),
            RoadQuestion(
                id: "lic-gdl2-night-curfew",
                prompt: "Under Michigan GDL Level 2 license restrictions, what nighttime driving curfew is enforced without an adult or approved work/school exemption?",
                options: [
                    "Between 9:00 p.m. and 6:00 a.m.",
                    "Between 10:00 p.m. and 5:00 a.m.",
                    "Between midnight and 5:00 a.m.",
                ],
                correctAnswer: 1,
                explanation:
                    "GDL Level 2 drivers are prohibited from driving between 10:00 p.m. and 5:00 a.m. unless accompanied by a parent/guardian/licensed adult 21+ or driving to/from authorized employment or activities.",
                source: "Chapter 1 · GDL Level 2 Intermediate License · p. 5"
            ),
            RoadQuestion(
                id: "lic-points-stay-duration",
                prompt: "How long do points posted to your Michigan driving record remain active?",
                options: [
                    "1 year from the date of the traffic stop",
                    "2 years from the date of conviction",
                    "7 years from the date of payment",
                ],
                correctAnswer: 1,
                explanation:
                    "Points assessed for moving traffic violations stay on your official Michigan driving record for two years from the date of conviction.",
                source: "Chapter 2 · Michigan’s point system · p. 13"
            ),
            RoadQuestion(
                id: "lic-reexam-threshold",
                prompt: "How many points accumulated on your Michigan driving record within a two-year period will trigger a mandatory driver reexamination?",
                options: [
                    "6 points",
                    "12 points",
                    "20 points",
                ],
                correctAnswer: 1,
                explanation:
                    "Accumulating 12 or more points within a two-year period triggers a mandatory driver assessment reexamination by the Secretary of State.",
                source: "Chapter 2 · Driver reexaminations · pp. 13–14, 16"
            ),
            RoadQuestion(
                id: "lic-points-owi-count",
                prompt: "How many points are placed on your driving record for Operating While Intoxicated (OWI) or refusing a chemical test?",
                options: [
                    "2 points",
                    "4 points",
                    "6 points",
                ],
                correctAnswer: 2,
                explanation:
                    "OWI and chemical test refusals both carry a maximum assessment of six points on your Michigan driving record.",
                source: "Chapter 2 · Six Points · p. 14"
            ),
            RoadQuestion(
                id: "lic-adult-bac",
                prompt: "In Michigan, a driver age 21 or older is considered legally intoxicated (OWI) at or above what Blood Alcohol Content (BAC)?",
                options: [
                    "0.05%",
                    "0.08%",
                    "0.10%",
                ],
                correctAnswer: 1,
                explanation:
                    "Under Michigan law, an adult driver age 21 or older is considered legally intoxicated with a bodily alcohol content of 0.08% or greater.",
                source: "Chapter 2 · Alcohol and drugs · p. 15"
            ),
            RoadQuestion(
                id: "lic-zero-tolerance-bac",
                prompt: "Under Michigan's Zero Tolerance law for drivers younger than age 21, what bodily alcohol content will result in penalties?",
                options: [
                    "0.02% or higher",
                    "0.05% or higher",
                    "0.08% or higher",
                ],
                correctAnswer: 0,
                explanation:
                    "Michigan enforces Zero Tolerance for minors under age 21: having a BAC of 0.02% or higher (or any presence of alcohol) is illegal and penalized.",
                source: "Chapter 2 · Alcohol and drugs · p. 15"
            ),
            RoadQuestion(
                id: "lic-implied-consent-law",
                prompt: "What does Michigan's 'Implied Consent' law state for licensed drivers?",
                options: [
                    "Drivers consent to vehicle searches at any time without reason",
                    "By driving on Michigan roads, you are considered to have consented to chemical tests for alcohol or drugs if requested by law enforcement",
                    "Drivers agree to pay all fines automatically without court hearings",
                ],
                correctAnswer: 1,
                explanation:
                    "Under Implied Consent, applying for a Michigan driver's license means you agree to take chemical breath, blood, or urine tests when requested by police. Refusal leads to an automatic 6 points and license suspension.",
                source: "Chapter 2 · Alcohol and drugs · p. 15"
            ),
        ]
    ),
    Lesson(
        id: "parking",
        icon: "parkingsign.circle",
        title: "Parking & lane maneuvers",
        summary: "Master curb distances, hill parking, and blind spots.",
        introduction:
            "Correct parking protects your car and keeps bike lanes and hydrants clear. Learn hill angles, parallel parking limits, and lane change safety.",
        questions: [
            RoadQuestion(
                id: "park-uphill-curb",
                prompt: "When parking facing UPHILL on a street with a curb, which way should you turn your vehicle's front wheels?",
                options: [
                    "Turn front wheels AWAY from the curb (toward the street)",
                    "Turn front wheels TOWARD the curb",
                    "Keep front wheels straight ahead",
                ],
                correctAnswer: 0,
                explanation:
                    "When parking uphill with a curb, turn your front wheels away from the curb (left) so the back of the front tire rolls against the curb if the car rolls backwards.",
                source: "Chapter 4 · Parking on a hill · p. 37"
            ),
            RoadQuestion(
                id: "park-downhill-curb",
                prompt: "When parking facing DOWNHILL along a street with a curb, which way should you turn your vehicle's front wheels?",
                options: [
                    "Turn front wheels AWAY from the curb",
                    "Turn front wheels TOWARD the curb (to the right)",
                    "Wheels may be pointed in any direction as long as the brake is set",
                ],
                correctAnswer: 1,
                explanation:
                    "When parking downhill with a curb, turn your front wheels toward the curb (right) so the car will roll into the curb if the brakes fail.",
                source: "Chapter 4 · Parking on a hill · p. 37"
            ),
            RoadQuestion(
                id: "park-curb-max-distance",
                prompt: "When parallel parking along a roadway curb, what is the maximum legal distance your vehicle may be parked from the curb?",
                options: [
                    "6 inches",
                    "12 inches (1 foot)",
                    "18 inches",
                ],
                correctAnswer: 1,
                explanation:
                    "Under Michigan law, a vehicle parked parallel to a curb must not be more than 12 inches (1 foot) away from the curb.",
                source: "Chapter 4 · Parallel parking · pp. 37–38"
            ),
            RoadQuestion(
                id: "park-fire-hydrant",
                prompt: "Under Michigan law, what is the minimum legal distance you must park away from a fire hydrant?",
                options: [
                    "At least 10 feet",
                    "At least 15 feet",
                    "At least 25 feet",
                ],
                correctAnswer: 1,
                explanation:
                    "Never park within 15 feet of a fire hydrant to ensure emergency firefighters have immediate, unhindered access.",
                source: "Chapter 4 · Parking violations · p. 38"
            ),
            RoadQuestion(
                id: "park-stop-sign",
                prompt: "What is the minimum distance you are legally permitted to park from a stop sign, traffic light, or flashing beacon?",
                options: [
                    "At least 15 feet",
                    "At least 30 feet",
                    "At least 50 feet",
                ],
                correctAnswer: 1,
                explanation:
                    "Parking within 30 feet of a stop sign, traffic control light, or flashing beacon is illegal because it obstructs driver visibility.",
                source: "Chapter 4 · Parking violations · p. 38"
            ),
            RoadQuestion(
                id: "park-crosswalk",
                prompt: "What is the minimum distance required when parking near a marked pedestrian crosswalk?",
                options: [
                    "At least 10 feet",
                    "At least 20 feet",
                    "At least 30 feet",
                ],
                correctAnswer: 1,
                explanation:
                    "You must never park within 20 feet of a pedestrian crosswalk to prevent blocking sightlines between pedestrians and drivers.",
                source: "Chapter 4 · Parking violations · p. 38"
            ),
            RoadQuestion(
                id: "park-rail-tracks",
                prompt: "Under Michigan law, how far away must you park from the nearest rail of a railroad crossing?",
                options: [
                    "At least 25 feet",
                    "At least 50 feet",
                    "At least 100 feet",
                ],
                correctAnswer: 1,
                explanation:
                    "Never park within 50 feet of the nearest rail of a railroad crossing.",
                source: "Chapter 4 · Parking violations · p. 38"
            ),
            RoadQuestion(
                id: "park-blind-spot-check",
                prompt: "When preparing to change lanes or pull out from a curb, what is the only way to check your vehicle's blind spots?",
                options: [
                    "Check your inside rearview mirror",
                    "Check your driver's side outside mirror",
                    "Turn your head and look over your shoulder in the direction you plan to move",
                ],
                correctAnswer: 2,
                explanation:
                    "Mirrors cannot show everything. The only reliable way to check your blind spot is to physically turn your head and glance over your shoulder before making the move.",
                source: "Safe Driving Knowledge Test · p. 70 / Chapter 4 · p. 34"
            ),
        ]
    ),
]

func completedQuestionIDs(stored: String) -> Set<String> {
    // Saved IDs are one string with commas between them. Split it into pieces.
    let savedPieces = stored.split(separator: ",")
    var ids: Set<String> = []

    for piece in savedPieces {
        let questionID = String(piece)
        ids.insert(questionID)
    }

    return ids
}

// Codable lets Swift turn drives into saved JSON text and read them back.
struct Drive: Codable, Identifiable {
    var id = UUID()
    var userID = ""
    var date: Date
    var dayMinutes: Int
    var nightMinutes: Int
    var skills: [String]

    var minutes: Int {
        return dayMinutes + nightMinutes
    }

    init(date: Date, dayMinutes: Int, nightMinutes: Int, skills: [String]) {
        self.date = date
        self.dayMinutes = dayMinutes
        self.nightMinutes = nightMinutes
        self.skills = skills
    }
}

// MARK: - Main tabs

// TabView creates the tab bar. Each tabItem supplies its text and SF Symbol icon.
struct ContentView: View {
    var body: some View {
        TabView {
            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "book.closed")
                }
            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "steeringwheel")
                }
            MentorsView()
                .tabItem {
                    Label("Mentors", systemImage: "person.2.fill")
                }
            ResourcesView()
                .tabItem {
                    Label("Resources", systemImage: "doc.text")
                }
        }
        .tint(.teal)
    }
}

// MARK: - Lesson list

struct LearnView: View {
    @EnvironmentObject var authentication: AuthenticationState
    @State private var enteredName = ""
    @State private var showGeneralAIChat = false
    // AppStorage keeps this value on the device, even after the app closes.
    @AppStorage("completedRoadQuestions") private var storedCompletions = ""
    private var completed: Set<String> {
        return completedQuestionIDs(stored: storedCompletions)
    }
    // This is recalculated when SwiftUI needs the current count.
    private var completedLessonCount: Int {
        var count = 0

        for lesson in lessons {
            if lesson.isComplete(completed: completed) {
                count += 1
            }
        }

        return count
    }

    private var progressMessage: String {
        if completedLessonCount > 0 {
            return "\(completedLessonCount) of \(lessons.count) lessons completed"
        } else {
            return "Start your first lesson"
        }
    }

    private var progressIcon: String {
        if completedLessonCount > 0 {
            return "checkmark.circle.fill"
        } else {
            return "flag.checkered"
        }
    }

    private var firstName: String {
        let nameParts = authentication.fullName.split(separator: " ")
        if let first = nameParts.first {
            return String(first)
        }
        return authentication.fullName
    }

    private func lessonStatus(lesson: Lesson) -> String {
        var status = "\(lesson.questions.count) QUESTIONS"

        if lesson.isComplete(completed: completed) {
            status += " · COMPLETED"
        }

        return status
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if let user = authentication.user {
                        if authentication.fullName.isEmpty {
                            HStack {
                                TextField("Enter your full name", text: $enteredName)
                                    .autocorrectionDisabled()
                                Button("Save") {
                                    authentication.fullName = enteredName
                                    UserDefaults.standard.set(enteredName, forKey: user.localId)
                                    enteredName = ""
                                }
                                .disabled(enteredName.isEmpty)
                            }
                            .padding()
                            .background(
                                Color(.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 18)
                            )
                        } else {
                            Text("Hi, " + firstName)
                                .font(.title2.bold())
                        }
                        HStack {
                            Text("Signed in as " + user.email)
                            Spacer()
                            Button("Sign out") {
                                authentication.signOut()
                            }
                            .foregroundStyle(.red)
                        }
                        .padding()
                        .background(
                            Color(.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                    } else {
                        MentorSignInPrompt(
                            message: "Sign in to sync your lesson progress across devices."
                        )
                        .padding(20)
                        .background(
                            Color(.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Label("MICHIGAN ROADREADY", systemImage: "sparkles")
                            .font(.caption.bold())
                        Text("Your road to\nindependence.")
                            .font(.largeTitle.bold())
                        Text("One lesson. One practice drive. One step closer.")
                        Label(progressMessage, systemImage: progressIcon)
                            .font(.subheadline.bold())
                            .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .foregroundStyle(.white)
                    .background(
                        Color(red: 0.04, green: 0.27, blue: 0.29),
                        in: RoundedRectangle(cornerRadius: 24)
                    )
                    Text("Build your road skills")
                        .font(.title2.bold())
                    ForEach(lessons) { lesson in
                        NavigationLink {
                            LessonView(lesson: lesson)
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: lesson.icon)
                                    .font(.title2)
                                    .foregroundStyle(.teal)
                                    .frame(width: 36)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(lesson.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(lesson.summary)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Text(lessonStatus(lesson: lesson))
                                        .font(.caption2.bold())
                                        .foregroundStyle(.teal)
                                }
                                Spacer(minLength: 0)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(
                                Color(.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 18)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    Text(
                        "Practice questions based on Michigan’s What Every Driver Must Know (October 2025)."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("MI DriveLab")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showGeneralAIChat = true
                    } label: {
                        Image(systemName: "sparkles.bubble.fill")
                            .foregroundStyle(.teal)
                    }
                }
            }
            .sheet(isPresented: $showGeneralAIChat) {
                DrivingAIChatSheet()
            }
        }
    }
}

// MARK: - Lesson questions

struct LessonView: View {
    let lesson: Lesson
    @EnvironmentObject var authentication: AuthenticationState
    // AppStorage keeps this value on the device, even after the app closes.
    @AppStorage("completedRoadQuestions") private var storedCompletions = ""
    // State updates the screen when a value changes. These answers last while this view is open.
    // The dictionary pairs a question ID with the selected answer position.
    @State private var answers: [String: Int] = [:]
    @State private var aiQuestion: RoadQuestion? = nil
    private var completed: Set<String> {
        return completedQuestionIDs(stored: storedCompletions)
    }
    private var completedCount: Int {
        var count = 0

        for question in lesson.questions {
            if completed.contains(question.id) {
                count += 1
            }
        }

        return count
    }

    private var progressIcon: String {
        if lesson.isComplete(completed: completed) {
            return "checkmark.circle.fill"
        } else {
            return "book.closed"
        }
    }

    private func selectAnswer(index: Int, question: RoadQuestion) {
        answers[question.id] = index
        if index == question.correctAnswer {
            var updated = completed
            updated.insert(question.id)
            // Sort the IDs and put commas between them to keep the same saved format.
            let sortedIDs = updated.sorted()
            let stored = sortedIDs.joined(separator: ",")
            storedCompletions = stored
            if let user = authentication.user {
                authentication.uploadCompletions(stored: stored, user: user)
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Image(systemName: lesson.icon)
                    .font(.system(size: 56))
                    .foregroundStyle(.teal)
                Text(lesson.title)
                    .font(.largeTitle.bold())
                Text(lesson.introduction)
                Label(
                    "\(completedCount) of \(lesson.questions.count) questions completed",
                    systemImage: progressIcon
                )
                .font(.subheadline.bold())
                .foregroundStyle(.teal)
                Text("Quick check")
                    .font(.title2.bold())
                // Array positions start at 0, so add 1 to show question numbers to the user.
                ForEach(lesson.questions.indices, id: \.self) { index in
                    let question = lesson.questions[index]

                    QuestionCard(
                        question: question,
                        number: index + 1,
                        answer: answers[question.id],
                        previouslyCompleted: completed.contains(question.id),
                        onSelect: { selectedIndex in
                            selectAnswer(index: selectedIndex, question: question)
                        },
                        onAskAI: { targetQuestion in
                            aiQuestion = targetQuestion
                        }
                    )
                    Divider()
                }
                Link("Read What Every Driver Must Know", destination: handbookURL)
                Text(
                    "Source: Michigan Department of State, October 2025 edition. These practice questions are not an official knowledge test."
                )
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .padding(24)
        }
        .navigationTitle("Lesson")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $aiQuestion) { targetQuestion in
            DrivingAIChatSheet(question: targetQuestion)
        }
    }
}

struct QuestionCard: View {
    let question: RoadQuestion
    let number: Int
    // The ? means there might not be an answer yet.
    let answer: Int?
    let previouslyCompleted: Bool
    // The parent view supplies this action. Call it when an answer is tapped.
    let onSelect: (Int) -> Void
    var onAskAI: ((RoadQuestion) -> Void)? = nil

    private var feedbackMessage: String {
        if answer == question.correctAnswer {
            return "Correct! " + question.explanation
        } else {
            return "Try again. " + question.explanation
        }
    }

    private var feedbackColor: Color {
        if answer == question.correctAnswer {
            return Color.teal
        } else {
            return Color.orange
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Question \(number)")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            Text(question.prompt)
                .font(.headline)
            ForEach(question.options.indices, id: \.self) { index in
                answerButton(index: index)
            }
            if answer != nil {
                Text(feedbackMessage)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(feedbackColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))

                // Show AI help option when the answer is incorrect
                if answer != question.correctAnswer {
                    Button {
                        onAskAI?(question)
                    } label: {
                        Label("Ask AI about this question", systemImage: "sparkles.bubble")
                            .font(.subheadline.bold())
                    }
                    .buttonStyle(.bordered)
                    .tint(.teal)
                }
            } else if previouslyCompleted {
                Label("Previously completed", systemImage: "checkmark.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.teal)
            }
            Text(question.source)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private func answerIcon(index: Int) -> String {
        if index == question.correctAnswer {
            return "checkmark.circle.fill"
        } else {
            return "arrow.clockwise"
        }
    }

    private func answerColor(index: Int) -> Color {
        if answer == index && index != question.correctAnswer {
            return Color.orange
        } else {
            return Color.teal
        }
    }

    // some View means this function builds a piece of the screen.
    private func answerButton(index: Int) -> some View {
        return Button {
            onSelect(index)
        } label: {
            HStack {
                Text(question.options[index])
                    .multilineTextAlignment(.leading)
                Spacer()
                if answer == index {
                    Image(systemName: answerIcon(index: index))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.bordered)
        .tint(answerColor(index: index))
    }
}

// MARK: - Practice journal
struct FirebaseSignInResponse:
    Decodable{
    let localId: String
    let email: String
    let idToken: String
    let refreshToken: String
    let expiresIn: String
    
    
}

struct UserProfile: Codable {
    var fullName: String
    var email: String
}

enum FirebaseConfig{
    static let apiKey =
    "AIzaSyByK8eUGurvPljADbe7Fp-PO-IgEmBhzEo"
    static let databaseURL =
    "https://mi-drivelab-default-rtdb.firebaseio.com"
}
struct SignInView: View{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authentication: AuthenticationState
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isSigningIn = false
    private func loadUserProfile(user: FirebaseSignInResponse) async {
        if let savedName = UserDefaults.standard.string(forKey: user.localId) {
            authentication.fullName = savedName
        } else {
            authentication.fullName = ""
        }
        let urlText = "\(FirebaseConfig.databaseURL)/users/\(user.localId).json?auth=\(user.idToken)"
        if let url = URL(string: urlText) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let profile = try decoder.decode(UserProfile.self, from: data)
                authentication.fullName = profile.fullName
                UserDefaults.standard.set(profile.fullName, forKey: user.localId)
            } catch {
                return
            }
        }
    }
    private func signIn() async {
        isSigningIn = true
        message = ""

        let urlText =
            "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=\(FirebaseConfig.apiKey)"

        guard let url = URL(string: urlText) else {
            message = "The sign-in URL is invalid."
            isSigningIn = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let details = [
            "email": email.trimmingCharacters(in: .whitespacesAndNewlines),
            "password": password,
            "returnSecureToken": true
        ] as [String: Any]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: details)

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(FirebaseSignInResponse.self,
                        from: data
                        )
                    authentication.user=user
                    await loadUserProfile(user: user)
                    await authentication.loadPlan(user: user)
                    await authentication.syncCompletions(user: user)
                    password = ""
                    message = "Signed in successfully!"
                    dismiss()
                } else {
                    message = "Sign-in failed. Check your email and password."
                }
            }
        } catch {
            message = "Could not sign in. Check your connection and try again."
        }

        isSigningIn = false
    }
    var body: some View{
        Form{
            if authentication.user != nil{
                Text("You are signed in")
            }
            
            Section("Sign in"){
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password", text: $password)
                    .textContentType(.oneTimeCode)
                    .autocorrectionDisabled()
            }
            Section{
                Button("Sign in"){
                    Task{
                        await signIn()
                    }
                }
                .foregroundStyle(.black)
                .listRowBackground(Color.teal)
                .disabled(isSigningIn||email.isEmpty||password.isEmpty)
                if isSigningIn{
                    ProgressView("Signing in...")
                }
                if message.isEmpty==false{
                Text(message)
                }
            }
            Section {
                NavigationLink("Need an account? Create one") {
                    SignUpView()
                }
            }
        }
        .navigationTitle("Sign in")
    }
}
struct PracticeRequest: Identifiable, Codable{
    var id = UUID()
    var sessionID: UUID
    var learnerID: String
    var volunteerID: String
    var message: String
    var carOption: CarOption
    var status: RequestStatus = .pending
    var learnerName: String? = nil
    var sessionArea: String? = nil
    var sessionStartTime: Date? = nil
    var sessionEndTime: Date? = nil
    var createdAt: Date? = nil
}

enum RequestStatus: String,Codable{
    case pending
    case accepted
    case declined
    case withdrawn
    case sessionUnavailable
    case sessionCancelled
    case sessionExpired
    case completed

    var title: String {
        switch self {
        case .pending: return "Pending"
        case .accepted: return "Accepted"
        case .declined: return "Declined"
        case .withdrawn: return "Withdrawn"
        case .sessionUnavailable: return "Session unavailable"
        case .sessionCancelled: return "Session cancelled by volunteer"
        case .sessionExpired: return "Session has passed"
        case .completed: return "Completed"
        }
    }
}
struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authentication: AuthenticationState
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isCreatingAccount = false
    @State private var showSetupSheet = false

    private func saveUserProfile(user: FirebaseSignInResponse, name: String) async {
        UserDefaults.standard.set(name, forKey: user.localId)
        let urlText = "\(FirebaseConfig.databaseURL)/users/\(user.localId).json?auth=\(user.idToken)"
        if let url = URL(string: urlText) {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let profile = UserProfile(fullName: name, email: user.email)

            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(profile)
                let (_, _) = try await URLSession.shared.data(for: request)
            } catch {
                return
            }
        }
    }

    private func signUp() async {
        isCreatingAccount = true
        message = ""

        let urlText =
            "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=\(FirebaseConfig.apiKey)"

        guard let url = URL(string: urlText) else {
            message = "The sign-up URL is invalid."
            isCreatingAccount = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let details = [
            "email": email.trimmingCharacters(in: .whitespacesAndNewlines),
            "password": password,
            "returnSecureToken": true
        ] as [String: Any]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: details)

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(
                        FirebaseSignInResponse.self,
                        from: data
                    )
                    await saveUserProfile(user: user, name: fullName)
                    authentication.user = user
                    authentication.fullName = fullName
                    // A new account starts with a fresh plan.
                    authentication.plan = DrivingPlan()
                    await authentication.syncCompletions(user: user)
                    password = ""
                    message = "Account created successfully!"
                    showSetupSheet = true
                } else {
                    message = "Could not create account. Use a valid email and a password of at least 6 characters."
                }
            }
        } catch {
            message = "Could not create account. Check your connection and try again."
        }

        isCreatingAccount = false
    }

    var body: some View {
        Form {
            Section("Create account") {
                TextField("Full name", text: $fullName)
                    .autocorrectionDisabled()
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password (6+ characters)", text: $password)
                    .textContentType(.oneTimeCode)
                    .autocorrectionDisabled()
            }
            Section {
                Button("Create account") {
                    Task {
                        await signUp()
                    }
                }
                .foregroundStyle(.black)
                .listRowBackground(Color.teal)
                .disabled(isCreatingAccount || fullName.isEmpty || email.isEmpty || password.isEmpty)
                if isCreatingAccount {
                    ProgressView("Creating account...")
                }
                if message.isEmpty == false {
                    Text(message)
                }
            }
        }
        .navigationTitle("Create account")
        .sheet(isPresented: $showSetupSheet, onDismiss: {
            dismiss()
        }) {
            PlanSetupView()
        }
    }
}

class AuthenticationState: ObservableObject{
    @Published var user: FirebaseSignInResponse?
    @Published var fullName = ""
    // Signed-out users see the default plan: the teen view with no saved answers.
    @Published var plan = DrivingPlan()

    // Saves the plan on this device and in Firebase. Only signed-in users can save.
    func savePlan(updatedPlan: DrivingPlan) {
        guard let user = user else {
            return
        }
        var newPlan = updatedPlan
        newPlan.updatedAt = Date()
        plan = newPlan
        PlanStore.saveLocalPlan(plan: newPlan, userID: user.localId)
        Task {
            await PlanStore.saveOnlinePlan(plan: newPlan, user: user)
        }
    }

    // Loads the newest copy of the plan after signing in.
    func loadPlan(user: FirebaseSignInResponse) async {
        let localPlan = PlanStore.loadLocalPlan(userID: user.localId)
        let onlinePlan = await PlanStore.loadOnlinePlan(user: user)

        if let localPlan = localPlan, let onlinePlan = onlinePlan {
            // Both copies exist. Use whichever was changed most recently.
            if localPlan.updatedAt > onlinePlan.updatedAt {
                plan = localPlan
                // The online copy is out of date (for example, a save failed), so upload again.
                await PlanStore.saveOnlinePlan(plan: localPlan, user: user)
            } else {
                plan = onlinePlan
                PlanStore.saveLocalPlan(plan: onlinePlan, userID: user.localId)
            }
        } else if let onlinePlan = onlinePlan {
            plan = onlinePlan
            PlanStore.saveLocalPlan(plan: onlinePlan, userID: user.localId)
        } else if let localPlan = localPlan {
            plan = localPlan
            await PlanStore.saveOnlinePlan(plan: localPlan, user: user)
        } else {
            plan = DrivingPlan()
        }
    }

    // Syncs completed road questions with Firebase so progress is saved across devices.
    func syncCompletions(user: FirebaseSignInResponse) async {
        let localCompletions = UserDefaults.standard.string(forKey: "completedRoadQuestions") ?? ""
        var merged = completedQuestionIDs(stored: localCompletions)

        let urlText = "\(FirebaseConfig.databaseURL)/users/\(user.localId)/completedRoadQuestions.json?auth=\(user.idToken)"
        if let url = URL(string: urlText) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let remoteString = try? JSONDecoder().decode(String.self, from: data) {
                    let remoteSet = completedQuestionIDs(stored: remoteString)
                    merged.formUnion(remoteSet)
                }
            } catch { }

            let mergedString = merged.sorted().joined(separator: ",")
            await MainActor.run {
                UserDefaults.standard.set(mergedString, forKey: "completedRoadQuestions")
            }

            if let uploadData = try? JSONEncoder().encode(mergedString) {
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = uploadData
                _ = try? await URLSession.shared.data(for: request)
            }
        }
    }

    func uploadCompletions(stored: String, user: FirebaseSignInResponse) {
        let urlText = "\(FirebaseConfig.databaseURL)/users/\(user.localId)/completedRoadQuestions.json?auth=\(user.idToken)"
        guard let url = URL(string: urlText),
              let uploadData = try? JSONEncoder().encode(stored) else { return }
        Task {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = uploadData
            _ = try? await URLSession.shared.data(for: request)
        }
    }

    func signOut() {
        user = nil
        fullName = ""
        plan = DrivingPlan()
    }
}
struct PracticeView: View {
    @EnvironmentObject var authentication: AuthenticationState
    @EnvironmentObject var mentors: MentorStore
    @AppStorage("practiceLogs") private var stored = "[]"
    @State private var showForm = false
    @State private var showSettings = false
    @State private var showSetup = false
    @State private var showSignInPrompt = false

    private var drives: [Drive] {
        let savedData = Data(stored.utf8)
        let decoder = JSONDecoder()

        do {
            let savedDrives = try decoder.decode([Drive].self, from: savedData)
            return savedDrives
        } catch {
            // If the saved text cannot be read, show an empty journal.
            return []
        }
    }

    private var userDrives: [Drive] {
        var matched: [Drive] = []
        for drive in drives {
            if drive.userID == authentication.user?.localId {
                matched.append(drive)
            }
        }
        return matched
    }

    private var totalHours: Double {
        var totalMinutes = 0
        if authentication.user != nil {
            totalMinutes += authentication.plan.priorDayMinutes + authentication.plan.priorNightMinutes
        }
        for drive in userDrives {
            totalMinutes += drive.minutes
        }
        return Double(totalMinutes) / 60
    }

    private var dayHours: Double {
        var minutes = 0
        if authentication.user != nil {
            minutes += authentication.plan.priorDayMinutes
        }
        for drive in userDrives {
            minutes += drive.dayMinutes
        }
        return Double(minutes) / 60
    }

    private var nightHours: Double {
        var minutes = 0
        if authentication.user != nil {
            minutes += authentication.plan.priorNightMinutes
        }
        for drive in userDrives {
            minutes += drive.nightMinutes
        }
        return Double(minutes) / 60
    }

    private func saveDrives(updatedDrives: [Drive]) {
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(updatedDrives)
            if let savedText = String(data: data, encoding: .utf8) {
                stored = savedText
            }
        } catch {
            // Keep the previous saved journal if encoding fails.
            return
        }
    }

    private func deleteDrives(at offsets: IndexSet) {
        var updatedDrives = drives
        for offset in offsets {
            let driveToDelete = userDrives[offset]
            for index in updatedDrives.indices {
                if updatedDrives[index].id == driveToDelete.id {
                    updatedDrives.remove(at: index)
                    break
                }
            }
        }
        saveDrives(updatedDrives: updatedDrives)
    }

    private func addDrive(drive: Drive) {
        var newDrive = drive
        if let user = authentication.user {
            newDrive.userID = user.localId
        }
        var updatedDrives = drives
        updatedDrives.insert(newDrive, at: 0)
        saveDrives(updatedDrives: updatedDrives)
    }

    private func driveDetails(drive: Drive) -> String {
        let dateText = drive.date.formatted(date: .abbreviated, time: .omitted)
        return "\(drive.minutes) min total · \(drive.dayMinutes) min day · \(drive.nightMinutes) min night · \(dateText)"
    }

    var body: some View {
        NavigationStack {
            List {
                // Top roadmap card: always visible so anyone can track and explore the steps.
                Section {
                    RoadmapHeaderCard()
                }

                if authentication.user == nil {
                    // Signed-out visitors see the GDL intro and sign-in prompt.
                    Section {
                        GDLIntroCard {
                            showSignInPrompt = true
                        }
                    }

                    Section {
                        MentorSignInPrompt(
                            message: "Sign in to personalize your progress goals, track permit countdowns, and record practice drives."
                        )
                        .padding(.vertical, 4)
                    }
                } else {
                    let plan = authentication.plan

                    // GDL intro card shown if teen user hasn't completed questionnaire yet.
                    if plan.isAdult == false && plan.completedSetup == false {
                        Section {
                            GDLIntroCard {
                                showSetup = true
                            }
                        }
                    }

                    // Dismissible note for 18+ drivers.
                    if plan.isAdult == false && plan.dismissedAdultNote == false {
                        Section {
                            AdultDismissibleNoteCard(
                                onSetupAdult: {
                                    showSettings = true
                                },
                                onDismiss: {
                                    var updated = plan
                                    updated.dismissedAdultNote = true
                                    authentication.savePlan(updatedPlan: updated)
                                }
                            )
                        }
                    }

                    // Next step card based on current stage and logged hours.
                    Section {
                        NextStepCard(plan: plan, totalHours: totalHours, nightHours: nightHours)
                    }

                    // Progress bars: Segment 2, Skills test, permit countdowns, or 30-day adult TIP.
                    Section {
                        RequirementsProgressCard(plan: plan, totalHours: totalHours, nightHours: nightHours)
                    }

                    // Hours summary
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("TIME BEHIND THE WHEEL")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                Text(String(format: "%.1f hours", totalHours))
                                    .font(.largeTitle.bold())
                                Text(String(format: "Day: %.1f hours · Night: %.1f hours", dayHours, nightHours))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text("\(userDrives.count) saved practice sessions")
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "steeringwheel")
                                .font(.largeTitle)
                                .foregroundStyle(.teal)
                        }
                        .padding(.vertical, 10)

                        Button {
                            showForm = true
                        } label: {
                            Label("Log a practice drive", systemImage: "plus.circle.fill")
                        }
                    }

                    // Journal section
                    let priorMinutes = plan.priorDayMinutes + plan.priorNightMinutes
                    Section("Your practice journal") {
                        // Pinned prior hours row (cannot be deleted by swiping; tap to edit in settings).
                        if priorMinutes > 0 {
                            Button {
                                showSettings = true
                            } label: {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "pin.fill")
                                        .foregroundStyle(.orange)
                                        .padding(.top, 2)
                                    VStack(alignment: .leading, spacing: 3) {
                                        HStack {
                                            Text("Prior practice hours")
                                                .font(.headline)
                                                .foregroundStyle(.primary)
                                            Spacer()
                                            Text("PINNED")
                                                .font(.caption2.bold())
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.orange.opacity(0.15), in: Capsule())
                                                .foregroundStyle(.orange)
                                        }
                                        Text(String(
                                            format: "%.1f h day · %.1f h night · Logged before app",
                                            Double(plan.priorDayMinutes) / 60.0,
                                            Double(plan.priorNightMinutes) / 60.0
                                        ))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }

                        if userDrives.isEmpty && priorMinutes == 0 {
                            ContentUnavailableView(
                                "Your journey starts here",
                                systemImage: "road.lanes",
                                description: Text(
                                    "After a supervised drive, record your time and the skill you practiced."
                                )
                            )
                        }

                        ForEach(userDrives) { drive in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(drive.skills.joined(separator: ", "))
                                    .font(.headline)
                                Text(driveDetails(drive: drive))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete { offsets in
                            deleteDrives(at: offsets)
                        }
                    }
                }

                Section {
                    Text(
                        "Use the app before or after driving. Practice with an eligible supervising adult. This personal journal is not an official licensing record."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Practice")
            .toolbar {
                if authentication.user != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                        .accessibilityLabel("Plan settings")
                    }
                }
            }
            .sheet(isPresented: $showForm) {
                DriveForm { drive in
                    addDrive(drive: drive)
                }
            }
            .sheet(isPresented: $showSettings) {
                PlanSettingsView()
            }
            .sheet(isPresented: $showSetup) {
                PlanSetupView()
            }
            .sheet(isPresented: $showSignInPrompt) {
                AccountPromptSheet(message: "Sign in to save a personalized Michigan driving plan and record your practice.")
            }
            .onAppear {
                if let user = authentication.user {
                    for request in mentors.myRequests {
                        if let session = mentors.sessions.first(where: { $0.id == request.sessionID }),
                           session.completedAt != nil {
                            autoLogCompletedMentorSession(session: session, learnerID: user.localId)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Add a practice drive

struct DriveForm: View {
    // SwiftUI provides dismiss so Cancel and Save can close this form.
    @Environment(\.dismiss) private var dismiss
    @State private var date = Date()
    @State private var dayMinutes = 30
    @State private var nightMinutes = 0
    @State private var selectedSkills = ["Parking"]
    // This action sends the new drive back to PracticeView.
    let onSave: (Drive) -> Void
    private let skills = [
        "Parking",
        "Turns",
        "Signs & right-of-way",
        "Highway merging",
        "Roundabouts",
        "Winter driving",
        "General driving",
    ]

    private func saveDrive() {
        if canSave == false {
            return
        }
        let newDrive = Drive(
            date: date,
            dayMinutes: dayMinutes,
            nightMinutes: nightMinutes,
            skills: selectedSkills
        )
        onSave(newDrive)
        dismiss()
    }

    private var canSave: Bool {
        if selectedSkills.isEmpty {
            return false
        }
        if dayMinutes + nightMinutes == 0 {
            return false
        }
        return true
    }

    private func toggleSkill(skill: String) {
        if let index = selectedSkills.firstIndex(of: skill) {
            selectedSkills.remove(at: index)
        } else {
            selectedSkills.append(skill)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                // $ connects each control to its State value so changes go both ways.
                DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                Section("Practice time") {
                    Stepper("Day: \(dayMinutes) minutes", value: $dayMinutes, in: 0...(240 - nightMinutes), step: 5)
                    Stepper("Night: \(nightMinutes) minutes", value: $nightMinutes, in: 0...(240 - dayMinutes), step: 5)
                    Text("Total: \(dayMinutes + nightMinutes) minutes")
                        .foregroundStyle(.secondary)
                }
                Section("Skills practiced · Select all that apply") {
                    ForEach(skills, id: \.self) { skillName in
                        Button {
                            toggleSkill(skill: skillName)
                        } label: {
                            HStack {
                                Text(skillName)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if selectedSkills.contains(skillName) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.teal)
                                }
                            }
                        }
                        .accessibilityValue(selectedSkills.contains(skillName) ? "Selected" : "Not selected")
                    }
                }
            }
            .navigationTitle("Log a drive")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveDrive()
                    }
                    .disabled(canSave == false)
                }
            }
        }
    }
}

// MARK: - Resources

struct ResourcesView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Image(systemName: "doc.text.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.teal)
                        Text("Michigan Driver Resources")
                            .font(.title2.bold())
                        Text("Official guides, study materials, and state requirements to help you get road-ready.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 12)
                }
                Section("Resource starting points") {
                    Link(
                        destination: URL(
                            string:
                                "https://www.michigan.gov/sos/all-services/first-time-license-or-id"
                        )!
                    ) {
                        Label(
                            "Michigan licensing & driver education",
                            systemImage: "building.columns"
                        )
                    }
                    Link(
                        destination: URL(
                            string:
                                "https://www.michigan.gov/sos/-/media/Project/Websites/sos/Resources/Forms-and-publications/WEDMK/WEDMK.pdf?rev=a00208f1ca1a48f9bce507c6a07531cf&hash=99BBCD52F327EB2B6986115DC6D785B0"
                        )!
                    ) {
                        Label(
                            "Michigan driving handbook 'What Every Driver Must Know'",
                            systemImage: "map"
                        )
                    }
                    Text(
                        "These links open external resources. Ask providers about availability, cost, eligibility, and transportation assistance; driving support is not guaranteed."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                Section("Explore Michigan Automotive") {
                    NavigationLink {
                        ExploreMichiganView()
                    } label: {
                        Label("Made in Michigan. Moving forward.", systemImage: "bolt.car")
                    }
                    Text(
                        "Mini lessons about auto history, EVs, and how cameras, radar, and LiDAR support driver-assistance technology."
                    )
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Resources")
        }
    }
}

typealias ConnectView = ResourcesView

// MARK: - Michigan automotive resources

struct ExploreMichiganView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Made in Michigan. Moving forward.", systemImage: "bolt.car")
                        .font(.title2.bold())
                        .foregroundStyle(.teal)
                    Text("Explore automotive history, electric vehicles, and the technology that helps drivers today.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 12)
            }

            Section("Michigan automotive history") {
                Label("Driving America", systemImage: "car.side")
                    .font(.headline)
                Text("The Henry Ford’s Driving America exhibit in Dearborn explores how cars changed everyday life and American culture. Its collection includes early automobiles, Henry Ford’s first gasoline-powered vehicle, and a hybrid Prius.")
                Text("Source: The Henry Ford")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Link(
                    "Learn more about automotive history",
                    destination: URL(string: "https://www.thehenryford.org/visit/venues/henry-ford-museum-of-american-innovation/driving-america")!
                )
            }

            Section("Electric vehicles") {
                Label("How electric cars work", systemImage: "bolt.car")
                    .font(.headline)
                Text("All-electric cars use an electric motor powered by a rechargeable battery instead of a gasoline engine. This guide explains the battery, charging port, motor, and other parts that work together to move the car.")
                Text("Source: Alternative Fuels Data Center")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Link(
                    "Learn more about electric cars",
                    destination: URL(string: "https://afdc.energy.gov/vehicles/how-do-all-electric-cars-work")!
                )
            }

            Section("Driver-assistance technology") {
                Label("Technology that supports drivers", systemImage: "sensor")
                    .font(.headline)
                Text("Features such as blind-spot warnings, automatic emergency braking, and lane-keeping assistance can warn drivers or help avoid a crash. NHTSA explains how these systems work. Drivers still need to stay attentive and understand their vehicle’s features.")
                Text("Source: National Highway Traffic Safety Administration (NHTSA)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Link(
                    "Learn more about driver-assistance technology",
                    destination: URL(string: "https://www.nhtsa.gov/vehicle-safety/driver-assistance-technologies")!
                )
            }

            Section {
                Text("Learn more links open external websites.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Explore Automotive")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.teal)
    }
}

struct PracticeSession: Identifiable, Codable{
    var id=UUID()
    var volunteerID = ""
    var volunteerName = ""
    var startTime: Date
    var endTime: Date
    var area: String
    var skills: [String]
    var notes: String
    var carOption: CarOption
    // Optional so sessions saved before cancellation was added still load.
    var cancelledAt: Date? = nil
    var acceptedLearnerID: String? = nil
    var completedAt: Date? = nil

    
}
// Firebase returns sessions keyed by UUID, rather than a JSON array.
enum CarOption: String, Codable{
    case learnersCar
    case volunteersCar
    case eitherCar
}
let exampleSession=PracticeSession(
    startTime: Date(),
    endTime: Date().addingTimeInterval(3600),
    area: "Ann Arbor",
    skills: ["Parking", "Turns"],
    notes: "Volunteer is a bald eagle beware",
    carOption: .eitherCar)

struct CitySearchResponse: Codable {
    var results: [CityResult]?
}

struct CityResult: Codable {
    var name: String
    var admin1: String?
    var postcodes: [String]?
}

struct PostSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authentication: AuthenticationState
    var existingSession: PracticeSession? = nil
    @State private var area = ""
    @State private var draftID = UUID()
    @State private var isSaving = false
    @State private var saveError = ""
    @State private var suggestions: [String] = []
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)
    @State private var selectedSkills: [String]=[]
    @State private var notes = ""
    @State private var carOption: CarOption = .eitherCar
    let onSave: (PracticeSession) async throws -> Void
    private let skills=[
        "Parking",
        "Turns",
        "Signs & right-of-way",
        "Highway merging",
        "Roundabouts",
        "General driving"
    ]
    private func searchCities() async {
        if area.count < 2 || suggestions.contains(area) {
            suggestions = []
            return
        }
        if let session = existingSession {
            if area == session.area {
                suggestions = []
                return
            }
        }

        let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(area)&count=5&countryCode=US"
        if let url = URL(string: urlString) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(CitySearchResponse.self, from: data)
                var foundCities: [String] = []

                if let results = decoded.results {
                    for city in results {
                        if let state = city.admin1 {
                            var label = city.name + ", " + state
                            if let postcodes = city.postcodes {
                                if let zip = postcodes.first {
                                    label = label + " " + zip
                                }
                            }
                            if foundCities.contains(label) == false {
                                foundCities.append(label)
                            }
                        }
                    }
                }

                suggestions = foundCities
            } catch {
                return
            }
        }
    }
    private func toggleSkill(skill: String){
        if selectedSkills.contains(skill){
            if let index = selectedSkills.firstIndex(of: skill){
                selectedSkills.remove(at: index)
            }
        }else{
            selectedSkills.append(skill)
        }
    }
    private var canSave: Bool{
        let cleanedArea = area.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedArea.isEmpty{
            return false
        }
        if startTime <= Date() { return false }
        if endTime<=startTime{
            return false
        }
        if selectedSkills.isEmpty{
            return false
        }
        return true
    }
    @MainActor
    private func saveSession() async {
        guard canSave, !isSaving, let user = authentication.user else { return }
        isSaving = true
        saveError = ""
        defer { isSaving = false }
        var newSession = existingSession ?? PracticeSession(
            volunteerID: user.localId, volunteerName: authentication.fullName,
            startTime: startTime, endTime: endTime, area: area,
            skills: selectedSkills, notes: notes, carOption: carOption
        )
        newSession.id = existingSession?.id ?? draftID
        newSession.startTime = startTime
        newSession.endTime = endTime
        newSession.area = area.trimmingCharacters(in: .whitespacesAndNewlines)
        newSession.skills = selectedSkills
        newSession.notes = notes
        newSession.carOption = carOption
        if newSession.volunteerName.isEmpty { newSession.volunteerName = "Volunteer" }
        do {
            try await onSave(newSession)
            dismiss()
        } catch {
            saveError = error.localizedDescription
        }
    }

    var body: some View {
        Form {
            Section("Location") {
                TextField("City or neighborhood", text: $area)
                    .autocorrectionDisabled()
                    .task(id: area) {
                        do {
                            try await Task.sleep(for: .seconds(0.3))
                            await searchCities()
                        } catch { return }
                    }

                ForEach(suggestions, id: \.self) { city in
                    Button {
                        area = city
                    } label: {
                        Text(city)
                    }
                }
            }
            
            Section("Date & time") {
                DatePicker(
                    "Starts",
                    selection: $startTime,
                    displayedComponents: [.date, .hourAndMinute]
                )
                DatePicker(
                    "Ends",
                    selection: $endTime,
                    in: startTime...,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            Section("Car options"){
                Picker("Car to use", selection: $carOption){
                    Text("Learner's car").tag(CarOption.learnersCar)
                    Text("Volunteer's car").tag(CarOption.volunteersCar)
                    Text("Either's car").tag(CarOption.eitherCar)
                    
                }
            }
            Section("Skills offered"){
                ForEach(skills, id:\.self) {skill in
                    Button{
                        toggleSkill(skill: skill)
                    } label:{
                        HStack{
                            Text(skill)
                            Spacer()
                            
                            if selectedSkills.contains(skill){
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            Section("Additional notes"){
                TextField("Optional notes", text: $notes, axis: .vertical)
            }
            Section{
                Button("Save session"){
                    Task { await saveSession() }
                }
                .disabled(!canSave || isSaving)
                if isSaving { ProgressView("Saving session…") }
                if !saveError.isEmpty { Text(saveError).foregroundStyle(.red) }
            }
            
        }
        .disabled(isSaving)
        .navigationTitle(existingSession == nil ? "Post a session" : "Edit session")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.teal)
        .onAppear {
            if let session = existingSession {
                area = session.area
                startTime = session.startTime
                endTime = session.endTime
                selectedSkills = session.skills
                notes = session.notes
                carOption = session.carOption
            }
        }
    }
}
