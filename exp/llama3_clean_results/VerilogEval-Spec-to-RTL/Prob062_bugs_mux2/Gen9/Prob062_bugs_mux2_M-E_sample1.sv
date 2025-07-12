// Novel 8-bit 2-to-1 multiplexer implementation using explicit bit-level control
module TopModule (
    input        sel, // Select signal
    input  [7:0] a,   // First 8-bit input
    input  [7:0] b,   // Second 8-bit input
    output [7:0] out  // Selected 8-bit output
);

    // Create a mask based on the select signal
    wire [7:0] sel_mask;
    assign sel_mask = {8{sel}};

    // Use bitwise operations to select between 'a' and 'b'
    // If sel is high, sel_mask will be all ones, selecting 'b'; otherwise, it selects 'a'
    assign out = (sel_mask & b) | (~sel_mask & a);

endmodule