module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized to 3 simpler product terms
assign out = (~a & ~d) | (~b & c) | (a & b & ~c);

endmodule