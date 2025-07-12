module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Define constants for arrow key scancodes
    localparam [15:0] LEFT_SCANCODE  = 16'he06b;
    localparam [15:0] DOWN_SCANCODE  = 16'he072;
    localparam [15:0] RIGHT_SCANCODE = 16'he074;
    localparam [15:0] UP_SCANCODE    = 16'he075;

    // Combinationally assign each output to 1 if scancode matches the corresponding key
    assign left  = (scancode == LEFT_SCANCODE);
    assign down  = (scancode == DOWN_SCANCODE);
    assign right = (scancode == RIGHT_SCANCODE);
    assign up    = (scancode == UP_SCANCODE);

endmodule