module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

// Define parameters for the arrow key scancodes
localparam [15:0] SC_LEFT  = 16'he06b;
localparam [15:0] SC_DOWN  = 16'he072;
localparam [15:0] SC_RIGHT = 16'he074;
localparam [15:0] SC_UP    = 16'he075;

// Each output is asserted when scancode matches its specific code
assign left  = (scancode == SC_LEFT);
assign down  = (scancode == SC_DOWN);
assign right = (scancode == SC_RIGHT);
assign up    = (scancode == SC_UP);

endmodule