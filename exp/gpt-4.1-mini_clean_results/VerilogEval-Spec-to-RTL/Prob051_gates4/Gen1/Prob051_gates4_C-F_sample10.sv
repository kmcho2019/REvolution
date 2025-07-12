module TopModule (
    input  [3:0] in,
    output       out_and, // 4-input AND reduction of 'in'
    output       out_or,  // 4-input OR  reduction of 'in'
    output       out_xor  // 4-input XOR reduction of 'in'
);

// Use Verilog reduction operators to compute outputs combinationally
assign out_and = &in;
assign out_or  = |in;
assign out_xor = ^in;

endmodule