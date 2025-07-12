// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Directly compute the bitwise OR within the TopModule
    assign out_or_bitwise = a | b;

    // Compute the logical OR by checking if the bitwise OR result is non-zero
    assign out_or_logical = |out_or_bitwise; // Using the reduction OR operator

    // Invert vectors a and b directly in the TopModule
    assign out_not[5:3] = ~b;
    assign out_not[2:0] = ~a;
endmodule