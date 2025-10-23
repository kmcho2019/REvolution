module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;
    
    // Simplified overflow detection logic with reduced area and power overhead
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]) ? 1'b1 : 1'b0;

endmodule