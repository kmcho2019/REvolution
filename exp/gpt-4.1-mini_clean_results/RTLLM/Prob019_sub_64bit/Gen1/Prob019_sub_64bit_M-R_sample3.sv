module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Intermediate subtraction result
    wire [63:0] diff;
    assign diff = A - B;

    // Sign bits
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire diff_sign   = diff[63];

    // Overflow conditions
    wire pos_overflow = (~A_sign) & B_sign & diff_sign;  // A positive, B negative, result negative
    wire neg_overflow = A_sign & (~B_sign) & (~diff_sign); // A negative, B positive, result positive

    assign overflow = pos_overflow | neg_overflow;
    assign result = diff;

endmodule