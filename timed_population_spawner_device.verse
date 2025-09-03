using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Random }

# This device manages periodic growth of a creature population by spawning creatures at specified spawners.
# It uses a timer to trigger spawns at regular intervals. When the time is finished, it randomly selects one of the configured spawners to spawn a creature.

# Enum to select spawning method
spawn_method := enum{SelectOneRandomSpawner, SpawnFromAll}

# Device that periodically triggers creature spawns from multiple spawner devices
creature_population_growth_device := class(creative_device):
    @editable
    CreatureSpawners: []npc_spawner_device = array{}

    @editable
    GrowthTimer: timer_device = timer_device{}

    @editable
    SpawnMethod: spawn_method = spawn_method.SpawnFromAll

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # Start the growth timer
        GrowthTimer.Start()
        # Subscribe to the timer's success event to trigger spawns
        GrowthTimer.SuccessEvent.Subscribe(OnGrowthTimerSuccess)

    # Called when the growth timer completes successfully
    OnGrowthTimerSuccess(Agent:?agent):void=
        if (CreatureSpawners.Length > 0):
            case(SpawnMethod):
                spawn_method.SelectOneRandomSpawner =>
                    RandomIndex := GetRandomInt(0, CreatureSpawners.Length - 1)
                    if (Spawner := CreatureSpawners[RandomIndex]):
                        Spawner.Spawn()
                spawn_method.SpawnFromAll =>
                    for (Spawner : CreatureSpawners):
                        Spawner.Spawn()
        # Restart the timer for continuous growth
        GrowthTimer.Start()