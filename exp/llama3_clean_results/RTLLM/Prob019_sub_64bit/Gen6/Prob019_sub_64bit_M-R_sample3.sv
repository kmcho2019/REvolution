module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform binary subtraction of A and B and detect overflow
    always @(*) begin
        result = A - B;
        // Simplified overflow detection logic
        overflow = (A[63]!= B[63]) && (A[63]!= result[63]);
    end

endmodule