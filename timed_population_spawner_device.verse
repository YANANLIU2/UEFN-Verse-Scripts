using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Random }


# Enum to select spawning method
spawn_method := enum{SelectOneRandomSpawner, SpawnFromAll}

# This device manages periodic growth of a creature population by spawning creatures at specified spawners.
# It uses a timer to trigger spawns at regular intervals. When the time is finished, it randomly selects one of the configured spawners to spawn a creature.

timed_population_spawner_device := class(creative_device):
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
        # Subscribe the correct spawn function based on the selected method
        case(SpawnMethod):
            spawn_method.SelectOneRandomSpawner =>
                GrowthTimer.SuccessEvent.Subscribe(SelectOneRandomSpawner)
            spawn_method.SpawnFromAll =>
                GrowthTimer.SuccessEvent.Subscribe(SpawnFromAll)
 
    # Spawns from all spawners
    SpawnFromAll(Agent:?agent):void=
        for (Spawner : CreatureSpawners):
            Spawner.Spawn()
        GrowthTimer.Start()
 
    # Spawns from a random spawner
    SelectOneRandomSpawner(Agent:?agent):void=
        if (CreatureSpawners.Length > 0):
            RandomIndex := GetRandomInt(0, CreatureSpawners.Length - 1)
            if (Spawner := CreatureSpawners[RandomIndex]):
                Spawner.Spawn()
        GrowthTimer.Start()