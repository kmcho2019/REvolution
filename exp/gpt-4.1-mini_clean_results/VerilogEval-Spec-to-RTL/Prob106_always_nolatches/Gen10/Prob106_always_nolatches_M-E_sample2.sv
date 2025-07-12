module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

// Define the exact 16-bit scancode constants for the arrow keys
localparam [15:0] SC_LEFT  = 16'he06b;
localparam [15:0] SC_DOWN  = 16'he072;
localparam [15:0] SC_RIGHT = 16'he074;
localparam [15:0] SC_UP    = 16'he075;

// Outputs are high if scancode matches the corresponding constant
assign left  = (scancode == SC_LEFT);
assign down  = (scancode == SC_DOWN);
assign right = (scancode == SC_RIGHT);
assign up    = (scancode == SC_UP);

endmodule