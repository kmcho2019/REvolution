module TopModule(
    input  [2:0] a,     // 3-bit input a
    input  [2:0] b,     // 3-bit input b
    output [2:0] out_or_bitwise,  // 3-bit output for bitwise-OR of a and b
    output out_or_logical,       // 1-bit output for logical-OR of a and b
    output [5:0] out_not         // 6-bit output for NOT of a and b
);

    // Compute the bitwise-OR of a and b
    assign out_or_bitwise = a | b;

    // Compute the logical-OR of a and b
    assign out_or_logical = |a || |b;

    // Compute the bitwise-NOT of a and b
    assign out_not[5:3] = ~b;  // Inverse of b
    assign out_not[2:0] = ~a;  // Inverse of a

endmodule