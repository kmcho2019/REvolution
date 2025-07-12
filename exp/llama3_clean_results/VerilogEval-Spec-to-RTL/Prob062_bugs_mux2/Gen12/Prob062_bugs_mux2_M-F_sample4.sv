// Corrected 8-bit 2-to-1 multiplexer implementation addressing the original bug
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

    // Replicate the select signal across all bits to correctly select between a and b
    assign out = ({8{~sel}} & a) | ({8{sel}} & b);

endmodule