module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire ab_not_zero = a | b;
    wire a_xor_b = a ^ b;
    assign out = (c & ab_not_zero) | (~c & a_xor_b & ab_not_zero);
endmodule