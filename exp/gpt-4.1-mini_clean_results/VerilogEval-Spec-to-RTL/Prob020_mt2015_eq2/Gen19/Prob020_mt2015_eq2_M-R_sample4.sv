module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output reg    z
);

reg [1:0] xnor_bits;

always @(*) begin
    xnor_bits[1] = ~(A[1] ^ B[1]);
    xnor_bits[0] = ~(A[0] ^ B[0]);
    z = xnor_bits[1] & xnor_bits[0];
end

endmodule