// Refactored 8-bit 2-to-1 multiplexer implementation
module TopModule (
    input        sel, // Select signal
    input  [7:0] a,   // First 8-bit input
    input  [7:0] b,   // Second 8-bit input
    output [7:0] out  // Selected 8-bit output
);

    // Directly use the 'sel' signal to select between 'a' and 'b'
    assign out = sel ? b : a;

endmodule