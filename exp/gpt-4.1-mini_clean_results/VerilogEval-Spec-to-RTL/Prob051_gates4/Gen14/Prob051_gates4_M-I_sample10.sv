module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Use reduction operators for 4-input AND, OR, XOR directly
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;
endmodule