module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Compute bitwise-OR of a and b
    assign out_or_bitwise = a | b;

    // Compute logical-OR of a and b
    // Since the logical-OR operator in Verilog only works on single bits,
    // we use a bitwise-OR and then check if the result is non-zero.
    assign out_or_logical = (a | b) != 3'b000;

    // Compute inverse of a and b
    // Use bitwise NOT operator (~) to invert a and b
    // Place the inverse of b in the upper half of out_not
    // Place the inverse of a in the lower half of out_not
    assign out_not = {~b, ~a};

endmodule