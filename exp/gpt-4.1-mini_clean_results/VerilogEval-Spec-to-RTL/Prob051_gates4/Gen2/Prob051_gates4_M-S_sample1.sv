module TopModule (
    input  [3:0] in,
    output       out_and = &in,
    output       out_or  = |in,
    output       out_xor = ^in
);
endmodule