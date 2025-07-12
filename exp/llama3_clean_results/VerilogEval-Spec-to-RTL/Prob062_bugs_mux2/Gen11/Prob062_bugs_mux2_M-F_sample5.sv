// Corrected and optimized 8-bit 2-to-1 multiplexer implementation
module TopModule (
    // Select line input
    input        sel,
    // 8-bit input a
    input  [7:0] a,
    // 8-bit input b
    input  [7:0] b,
    // 8-bit output selected based on sel
    output [7:0] out
);

    // Assign the output based on the current select line and inputs
    assign out = sel ? b : a;

endmodule