module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Define known arrow key scancodes as localparams for clarity
    localparam [15:0] SC_LEFT  = 16'hE06B;
    localparam [15:0] SC_DOWN  = 16'hE072;
    localparam [15:0] SC_RIGHT = 16'hE074;
    localparam [15:0] SC_UP    = 16'hE075;

    // Each output is asserted if scancode matches corresponding scancode
    assign left  = (scancode == SC_LEFT);
    assign down  = (scancode == SC_DOWN);
    assign right = (scancode == SC_RIGHT);
    assign up    = (scancode == SC_UP);

endmodule