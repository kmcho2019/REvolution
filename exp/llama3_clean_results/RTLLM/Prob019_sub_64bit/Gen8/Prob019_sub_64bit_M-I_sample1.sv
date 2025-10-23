module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Explicit wire definition for the subtraction result
    wire [63:0] diff;

    // Perform subtraction
    assign diff = A - B;
    
    // Assign the result
    assign result = diff;
    
    // Simplified overflow detection logic
    assign overflow = (A[63]!= B[63]) && (A[63]!= result[63]);

endmodule