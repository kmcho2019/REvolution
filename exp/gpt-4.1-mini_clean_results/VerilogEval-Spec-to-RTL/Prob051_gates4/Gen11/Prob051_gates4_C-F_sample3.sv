module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    wire and_result;
    wire or_result;
    wire xor_result;

    // Use reduction operators for compact, efficient logic
    assign and_result = &in;
    assign or_result  = |in;
    assign xor_result = ^in;

    // Assign outputs from intermediate wires to clarify structure
    assign out_and = and_result;
    assign out_or  = or_result;
    assign out_xor = xor_result;

endmodule