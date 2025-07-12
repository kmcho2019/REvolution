module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Directly use Verilog reduction operators to get minimal and efficient logic
    assign out_and = &in;  // 4-input AND
    assign out_or  = |in;  // 4-input OR
    assign out_xor = ^in;  // 4-input XOR

endmodule