module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform direct subtraction
    assign result = A - B;

    // Overflow detection:
    // Overflow occurs if A and B have different signs,
    // and result sign differs from A sign.
    assign overflow = (A[63] ^ B[63]) & (result[63] ^ A[63]);

endmodule