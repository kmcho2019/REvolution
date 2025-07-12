module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Simplified Boolean expression
assign out = (~c) | (~a & ~d) | (b & d);

endmodule