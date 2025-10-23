module TopModule (
    input a,
    input b,
    output out
);
    // LUT-style XNOR implementation using a multiplexer
    // Truth table:
    // a b | out
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 1
    assign out = (a & b) ? 1'b1 :
                (a & ~b) ? 1'b0 :
                (~a & b) ? 1'b0 :
                1'b1;  // default case (~a & ~b)
endmodule