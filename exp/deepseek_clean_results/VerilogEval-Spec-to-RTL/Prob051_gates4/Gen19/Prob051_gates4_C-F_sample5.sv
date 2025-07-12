module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Outputs using Verilog reduction operators:
    assign out_and = &in;  // 4-input AND
    assign out_or  = |in;  // 4-input OR
    assign out_xor = ^in;  // 4-input XOR

endmodule