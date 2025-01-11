return {
    { type = "background", file = "backgrounds/bg_forest.png" },
    { type = "character", name = "Alice", expression = "characters/alice_happy", position = "left" },
    { type = "dialogue", name = "Alice", text = "What a beautiful day in the forest!", sound = "alice_talking.mp3" },
    { type = "dialogue", name = "Bob", text = "I agree, Alice! It's wonderful.", sound = "bob_talking.mp3" },
    { type = "dialogue", name = "Alice", text = "Shall we explore further?", sound = "alice_thinking.mp3" },
    { type = "choice", options = {
        { text = "Yes, let's go!", next = "scene_hello" },
        { text = "No, it's too dangerous.", next = "scene_ignore" }
    }}
}
