module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Declare the constants for each arrow key scancode
    localparam [15:0] LEFT_CODE  = 16'hE06B;
    localparam [15:0] DOWN_CODE  = 16'hE072;
    localparam [15:0] RIGHT_CODE = 16'hE074;
    localparam [15:0] UP_CODE    = 16'hE075;

    // Continuous assignment for each output based on exact equality to each code
    assign left  = (scancode == LEFT_CODE);
    assign down  = (scancode == DOWN_CODE);
    assign right = (scancode == RIGHT_CODE);
    assign up    = (scancode == UP_CODE);

endmodule