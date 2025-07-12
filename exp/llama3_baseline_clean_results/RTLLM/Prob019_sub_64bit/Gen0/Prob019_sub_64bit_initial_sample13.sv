module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

assign result = A - B;

always @(A, B, result) begin
    if ((A[63] == 0 && B[63] == 1 && result[63] == 1) || (A[63] == 1 && B[63] == 0 && result[63] == 0)) begin
        overflow = 1'b1;
    end else begin
        overflow = 1'b0;
    end
end

endmodule