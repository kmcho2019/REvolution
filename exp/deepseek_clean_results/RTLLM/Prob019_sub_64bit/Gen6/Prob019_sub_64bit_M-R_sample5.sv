module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output logic [63:0] result,
    output logic overflow
);

    always_comb begin
        // Perform the subtraction
        result = A - B;
        
        // Overflow detection logic
        overflow = (A[63] != B[63]) && (A[63] != result[63]);
    end

endmodule