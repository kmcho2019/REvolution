module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    // Define scancode constants for clarity
    localparam [15:0] SC_LEFT  = 16'he06b;
    localparam [15:0] SC_DOWN  = 16'he072;
    localparam [15:0] SC_RIGHT = 16'he074;
    localparam [15:0] SC_UP    = 16'he075;

    // Check upper byte to gate decoding (0xE0 prefix)
    wire is_e0 = (scancode[15:8] == 8'hE0);

    // Outputs asserted only if upper byte is 0xE0 and matching lower byte code
    assign left  = is_e0 && (scancode == SC_LEFT);
    assign down  = is_e0 && (scancode == SC_DOWN);
    assign right = is_e0 && (scancode == SC_RIGHT);
    assign up    = is_e0 && (scancode == SC_UP);

endmodule