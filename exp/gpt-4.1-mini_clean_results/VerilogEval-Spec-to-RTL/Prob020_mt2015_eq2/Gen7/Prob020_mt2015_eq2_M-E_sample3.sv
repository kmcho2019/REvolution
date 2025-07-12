module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [1:0] xor_bits;
wire       or_result;

xor u_xor0 (xor_bits[0], A[0], B[0]);
xor u_xor1 (xor_bits[1], A[1], B[1]);
or  u_or    (or_result, xor_bits[0], xor_bits[1]);
not u_not   (z, or_result);

endmodule