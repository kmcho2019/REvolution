module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Combined row and column parity check in one expression
    assign out = (a ^ b) ^ (c ^ d);
endmodule