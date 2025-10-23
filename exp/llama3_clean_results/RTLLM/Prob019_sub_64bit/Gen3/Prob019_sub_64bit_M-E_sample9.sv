module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Divide the 64-bit operands into two 32-bit segments
    wire [31:0] A_hi = A[63:32];
    wire [31:0] A_lo = A[31:0];
    wire [31:0] B_hi = B[63:32];
    wire [31:0] B_lo = B[31:0];

    // Perform subtraction for the lower 32 bits
    wire [31:0] diff_lo;
    wire         borrow_lo;
    assign {borrow_lo, diff_lo} = A_lo - B_lo;

    // Perform subtraction for the upper 32 bits, considering the borrow from the lower 32 bits
    wire [31:0] diff_hi;
    wire         borrow_hi;
    assign {borrow_hi, diff_hi} = A_hi - B_hi - borrow_lo;

    // Combine the results of the two segments
    assign result[31:0] = diff_lo;
    assign result[63:32] = diff_hi;

    // Detect overflow by checking the borrow from the upper 32 bits
    assign overflow = borrow_hi;

endmodule