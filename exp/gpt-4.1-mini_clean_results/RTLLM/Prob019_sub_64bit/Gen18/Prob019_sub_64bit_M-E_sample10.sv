module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] borrow;

    // First stage borrow_in is zero
    assign borrow[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : subtractor_chain
            full_subtractor u_full_subtractor (
                .a       (A[i]),
                .b       (B[i]),
                .borrow_in (borrow[i]),
                .diff    (result[i]),
                .borrow_out (borrow[i+1])
            );
        end
    endgenerate

    // borrow[64] is unused output borrow_out from MSB stage

    // Overflow detection
    // overflow = (A[63] == 0 && B[63] == 1 && result[63] == 1) || (A[63] == 1 && B[63] == 0 && result[63] == 0)
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire R_sign = result[63];

    assign overflow = (~A_sign & B_sign & R_sign) | (A_sign & ~B_sign & ~R_sign);

endmodule

// 1-bit full subtractor module: diff = a - b - borrow_in
module full_subtractor (
    input  wire a,
    input  wire b,
    input  wire borrow_in,
    output wire diff,
    output wire borrow_out
);
    // diff calculation: diff = a ^ b ^ borrow_in
    assign diff = a ^ b ^ borrow_in;

    // borrow_out calculation:
    // borrow_out = (~a & b) | ((~a | b) & borrow_in)
    // Explanation:
    // borrow is needed if (b > a) or (borrow_in and (b == a))
    assign borrow_out = (~a & b) | ((~a | b) & borrow_in);

endmodule