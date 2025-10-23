module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output reg  [63:0] result,
    output reg         overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;
    
    // Simplified overflow detection logic
    assign overflow = (A[63] == 1 && B[63] == 0 && result[63] == 1) || (A[63] == 0 && B[63] == 1 && result[63] == 0);

endmodule