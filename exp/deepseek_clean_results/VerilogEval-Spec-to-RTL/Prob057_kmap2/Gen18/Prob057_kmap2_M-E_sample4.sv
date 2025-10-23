module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire ab_xor = a ^ b;
wire cd_xor = c ^ d;
wire base_pattern = ~(ab_xor ^ cd_xor);

// Corrections for specific cases
wire case1 = a & b & ~c;
wire case2 = a & c & ~d;
wire case3 = ~a & b & ~c & d;

assign out = base_pattern | case1 | case2 | case3;

endmodule