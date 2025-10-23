module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Define scancode constants
    localparam LEFT_CODE  = 16'he06b;
    localparam DOWN_CODE  = 16'he072;
    localparam RIGHT_CODE = 16'he074;
    localparam UP_CODE    = 16'he075;

    // Parallel comparison for each arrow key
    assign left  = (scancode == LEFT_CODE);
    assign down  = (scancode == DOWN_CODE);
    assign right = (scancode == RIGHT_CODE);
    assign up    = (scancode == UP_CODE);

endmodule