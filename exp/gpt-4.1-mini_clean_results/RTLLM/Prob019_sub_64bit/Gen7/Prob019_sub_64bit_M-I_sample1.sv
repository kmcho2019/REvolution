module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction using built-in operator for efficient synthesis
    assign result = A - B;

    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow detection logic for subtraction:
    // Overflow occurs if sign of A differs from B and result sign differs from A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule