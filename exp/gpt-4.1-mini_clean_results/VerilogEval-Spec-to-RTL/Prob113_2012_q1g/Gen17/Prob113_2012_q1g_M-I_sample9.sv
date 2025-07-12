module TopModule(
    input  [3:0] x,
    output       f
);
    // Direct use of bits for clarity and compactness
    assign f = (~x[2] & ~x[3] & ~x[1]) | (x[2] & (~x[0] | ~(x[1] ^ x[3])));
endmodule