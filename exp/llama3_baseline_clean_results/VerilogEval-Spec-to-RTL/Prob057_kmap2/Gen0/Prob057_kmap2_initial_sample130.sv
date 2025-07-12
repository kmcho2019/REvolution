module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The Karnaugh map can be reduced to the following expression:
// out = (a'b + a'c'd + a'd + bc'd + b'c'd)
assign out = (~a & b) | (~a & ~c & ~d) | (~a & d) | (b & ~c & ~d) | (~b & c & ~d);

endmodule