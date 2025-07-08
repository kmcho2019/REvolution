module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] diff;
    assign diff = A - B;
    assign result = diff;

    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_res = diff[63];

    // Overflow detection:
    // Overflow when subtracting a negative from a positive yields negative result (positive overflow)
    // or subtracting a positive from a negative yields positive result (negative overflow)
    assign overflow = (sign_A == 1'b0 && sign_B == 1'b1 && sign_res == 1'b1) ||
                      (sign_A == 1'b1 && sign_B == 1'b0 && sign_res == 1'b0);

endmodule