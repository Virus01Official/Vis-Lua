return {
    { type = "background", file = "backgrounds/bg_forest.png" },
    { type = "character", name = "Alice", expression = "characters/alice_happy", position = "left" },
    { type = "dialogue", name = "Alice", text = "What a beautiful day in the forest!" },
    { type = "choice", options = {
        { text = "Greet Alice", next = "scene_hello" },
        { text = "Walk away", next = "scene_ignore" }
    }}
}
