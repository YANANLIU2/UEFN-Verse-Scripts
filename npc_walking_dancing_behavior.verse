using { /Fortnite.com/AI }
using { /Fortnite.com/Animation/PlayAnimation }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }

# Behavior class for NPCs to walk and dance
npc_walking_dancing_behavior := class(npc_behavior):
    @editable
    # Reference to the dance animation sequence
    DanceAnimationArray : []animation_sequence

    # How far NPC can wander from spawn
    WanderRadius : float = 500.0

    # How long to dance before walking again
    DanceDuration : float = 5.0

    # How long to walk before dancing again
    WalkDuration : float = 3.0

    # Main behavior loop
    OnBegin<override>()<suspends>:void =
        if:
            Agent := GetAgent[]
            Character := Agent.GetFortCharacter[]
            Navigatable := Character.GetNavigatable[]
            PlayAnimController := Character.GetPlayAnimationController[]
            SpawnLocation := Character.GetTransform().Translation
        then:
            loop:
                # Pick random point to walk to within radius
                RandomOffset := vector3{
                    X := GetRandomFloat(-WanderRadius, WanderRadius),
                    Y := GetRandomFloat(-WanderRadius, WanderRadius),
                    Z := 0.0
                }
                TargetLocation := SpawnLocation + RandomOffset

                # Walk to target location
                NavTarget := MakeNavigationTarget(TargetLocation)
                NavResult := Navigatable.NavigateTo(NavTarget)
                Sleep(WalkDuration)

                # Play a random dance animation
                ArrayLength := DanceAnimationArray.Length
                RandomIndex := GetRandomInt(0, ArrayLength - 1)
                if (RandomDance := DanceAnimationArray[RandomIndex]):
                    PlayAnimController.Play(RandomDance, ?PlayRate := 1.0, ?BlendInTime := 0.2, ?BlendOutTime := 0.2)
                Sleep(DanceDuration)