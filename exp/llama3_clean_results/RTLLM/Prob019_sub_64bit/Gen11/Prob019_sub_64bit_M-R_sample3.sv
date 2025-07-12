module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output reg  [63:0] result,
    output reg         overflow
);

    always @(*) begin
        // Perform binary subtraction of A and B
        result = A - B;
        
        // Simplified overflow detection logic
        if (A[63] == B[63] && A[63] != result[63]) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

endmodule