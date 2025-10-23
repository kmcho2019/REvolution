module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] or_bitwise;

    // Compute bitwise OR of inputs
    assign or_bitwise = a | b;

    // Output the bitwise OR result
    assign out_or_bitwise = or_bitwise;

    // Logical OR is reduction OR of bitwise OR result
    assign out_or_logical = |or_bitwise;

    // Invert inputs individually
    wire [2:0] inv_a = ~a;
    wire [2:0] inv_b = ~b;

    // Assign inverted b to upper half and inverted a to lower half of out_not
    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;

endmodule