module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output reg   z
);

wire bit_eq_0 = ~(A[0] ^ B[0]);
wire bit_eq_1 = ~(A[1] ^ B[1]);

always @(*) begin
    z = bit_eq_0 & bit_eq_1;
end

endmodule