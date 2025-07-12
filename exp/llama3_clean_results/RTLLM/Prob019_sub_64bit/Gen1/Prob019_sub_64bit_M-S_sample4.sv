module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    assign result = A - B;

    // Simplified overflow detection: 
    // Overflow occurs if A and result have different signs and A and B have different signs.
    always @(*) begin
        if ((A[63] != result[63]) && (A[63] != B[63])) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

endmodule