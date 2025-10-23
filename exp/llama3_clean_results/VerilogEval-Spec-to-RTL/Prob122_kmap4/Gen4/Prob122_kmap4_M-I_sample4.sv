module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signal for XOR operation between a and b
wire ab_xor = (a & ~b) | (~a & b);

assign out = ((~c & ~d) & ab_xor) |
             ((~c & d) & ~(ab_xor)) |
             ((c & d) & ab_xor) |
             ((c & ~d) & ~(ab_xor));

endmodule