module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Calculate bitwise differences from each target scancode
    wire [15:0] diff_left  = scancode ^ 16'he06b;
    wire [15:0] diff_down  = scancode ^ 16'he072;
    wire [15:0] diff_right = scancode ^ 16'he074;
    wire [15:0] diff_up    = scancode ^ 16'he075;

    // Detect exact matches (all bits equal)
    wire match_left  = ~|diff_left;  // NOR reduction
    wire match_down  = ~|diff_down;
    wire match_right = ~|diff_right;
    wire match_up    = ~|diff_up;

    // Direct assignment to outputs
    assign left  = match_left;
    assign down  = match_down;
    assign right = match_right;
    assign up    = match_up;

endmodule