module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire ab_xor = a ^ b;
wire cd_xor = c ^ d;
wire abc = a & b & c;
wire abd = a & b & d;
wire abcd_correction = ~a & ~b & c & d;

assign out = ab_xor ^ cd_xor ^ abc ^ abd ^ abcd_correction;

endmodule