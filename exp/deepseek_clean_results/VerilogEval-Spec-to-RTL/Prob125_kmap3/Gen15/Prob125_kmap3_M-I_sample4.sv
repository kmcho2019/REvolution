module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimized logic:
    // When a=1: output 1
    // Else: output (c ? ~b : 0)
    // Implemented without NOT operation by using ternary
    assign out = a ? 1'b1 : (c ? (b ? 1'b0 : 1'b1) : 1'b0);
endmodule