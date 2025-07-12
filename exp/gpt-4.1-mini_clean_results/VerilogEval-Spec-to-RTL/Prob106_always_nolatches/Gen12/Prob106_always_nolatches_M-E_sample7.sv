module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Define arrow key scancode constants
    localparam [15:0] LEFT_CODE  = 16'hE06B;
    localparam [15:0] DOWN_CODE  = 16'hE072;
    localparam [15:0] RIGHT_CODE = 16'hE074;
    localparam [15:0] UP_CODE    = 16'hE075;

    // Directly assign outputs by equality comparison
    assign left  = (scancode == LEFT_CODE);
    assign down  = (scancode == DOWN_CODE);
    assign right = (scancode == RIGHT_CODE);
    assign up    = (scancode == UP_CODE);

endmodule