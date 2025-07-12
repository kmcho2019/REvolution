module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(*) begin
    // Compute XOR of all inputs
    wire xor_all;
    xor_all = a ^ b ^ c ^ d;
    // q is the inversion of the XOR of all inputs
    q = ~xor_all;
end

endmodule