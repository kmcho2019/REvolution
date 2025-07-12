module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction using Verilog operator to enable optimized synthesis
    assign result = A - B;

    // Extract sign bits
    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow detection for subtraction
    // Overflow occurs when sign of A != sign of B and sign of result != sign of A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule