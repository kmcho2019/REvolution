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

    // Assign result
    assign result = diff;

    // Overflow detection logic
    assign overflow = (A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) || 
                     (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0);

endmodule