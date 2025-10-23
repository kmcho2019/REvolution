module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;
    
    // Simplified overflow detection logic
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

endmodule