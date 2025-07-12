module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Two's complement converter for B
    wire [63:0] b_twos_complement;
    assign b_twos_complement = ~B + 1;

    // 64-bit binary adder
    wire [63:0] adder_result;
    wire       carry_out;
    assign {carry_out, adder_result} = A + b_twos_complement;

    // Overflow detection logic
    assign overflow = carry_out ^ adder_result[63];

    // Assign the result
    assign result = adder_result;

endmodule