module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Overflow detection:
    // Overflow occurs if signs of A and B differ, and sign of result differs from sign of A
    assign overflow = (A[63] ^ B[63]) & (result[63] ^ A[63]);

endmodule