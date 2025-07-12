module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction as unsigned extended operation to capture borrow
    wire [64:0] diff_ext;
    assign diff_ext = {1'b0, A} - {1'b0, B};

    assign result = diff_ext[63:0];

    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow detection for subtraction:
    // Overflow if sign of A differs from sign of B
    // and sign of result differs from sign of A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule