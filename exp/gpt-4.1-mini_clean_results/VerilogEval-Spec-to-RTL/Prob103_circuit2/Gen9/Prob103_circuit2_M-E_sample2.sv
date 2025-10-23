module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire xor1, xor2, xor3;

assign xor1 = a ^ b;
assign xor2 = c ^ d;
assign xor3 = xor1 ^ xor2;
assign q = ~xor3;  // Invert parity bit to get even parity

endmodule