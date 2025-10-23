module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    assign result = A - B;
    
    always @(A, B, result) begin
        if ((~A[63] & B[63] & result[63]) | (A[63] & ~B[63] & ~result[63])) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

endmodule