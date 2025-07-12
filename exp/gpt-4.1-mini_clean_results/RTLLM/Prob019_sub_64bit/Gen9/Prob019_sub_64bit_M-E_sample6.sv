module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire borrow_lower;
    wire borrow_upper;

    wire [31:0] res_lower;
    wire [31:0] res_upper;

    // Lower 32-bit subtractor: subtract lower 32 bits of A and B with borrow in=0
    sub_32bit sub_lower (
        .A    (A[31:0]),
        .B    (B[31:0]),
        .bin  (1'b0),
        .diff (res_lower),
        .bout (borrow_lower)
    );

    // Upper 32-bit subtractor: subtract upper 32 bits of A and B with borrow from lower subtractor
    sub_32bit sub_upper (
        .A    (A[63:32]),
        .B    (B[63:32]),
        .bin  (borrow_lower),
        .diff (res_upper),
        .bout (borrow_upper)
    );

    assign result = {res_upper, res_lower};

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 32-bit ripple borrow subtractor: performs A - B - bin
// Borrow out (bout) is 1 when subtraction borrows out
module sub_32bit (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        bin,   // borrow in
    output wire [31:0] diff,
    output wire        bout   // borrow out
);
    wire [31:0] borrow;

    // First bit subtractor with borrow in = bin
    assign {borrow[0], diff[0]} = {1'b0, A[0]} - {1'b0, B[0]} - bin;

    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : bit_sub
            // diff[i] = A[i] - B[i] - borrow[i-1]
            // borrow[i] = 1 if borrow needed for next bit
            assign {borrow[i], diff[i]} = {1'b0, A[i]} - {1'b0, B[i]} - borrow[i-1];
        end
    endgenerate

    assign bout = borrow[31];

endmodule