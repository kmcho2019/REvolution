// Improved 8-bit 2-to-1 multiplexer module
module TopModule (
    input        sel, // Select signal
    input  [7:0] a,   // First 8-bit input
    input  [7:0] b,   // Second 8-bit input
    output [7:0] out  // Selected 8-bit output
);

    // Use a continuous assignment to select between 'a' and 'b' based on 'sel'
    assign out = sel? b : a;

endmodule