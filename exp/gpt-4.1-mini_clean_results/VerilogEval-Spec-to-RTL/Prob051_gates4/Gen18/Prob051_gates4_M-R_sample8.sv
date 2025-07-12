module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Directly assign outputs using reduction operators for minimal, clear combinational logic
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;
endmodule