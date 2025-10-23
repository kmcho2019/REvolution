module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Directly assign the result of the subtraction to the output port
    assign result = A - B;
    
    // Utilize the effective overflow detection logic with minor optimization
    // This optimization does not change the functionality but is a minor refactoring
    assign overflow = (A[63] != B[63]) && (result[63] != A[63]);

endmodule