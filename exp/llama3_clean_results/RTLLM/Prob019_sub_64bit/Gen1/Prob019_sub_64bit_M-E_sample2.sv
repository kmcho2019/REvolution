module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Check for overflow conditions
    always @(*) begin
        // Initialize overflow flag to 0
        overflow = 1'b0;
        
        // Check for positive overflow: A is positive, B is negative, result is negative
        if (~A[63] && B[63] && result[63]) begin
            overflow = 1'b1;
        end 
        // Check for negative overflow: A is negative, B is positive, result is positive
        else if (A[63] && ~B[63] && ~result[63]) begin
            overflow = 1'b1;
        end
    end

endmodule