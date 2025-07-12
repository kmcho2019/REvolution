module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire borrow_low;
    wire borrow_high;

    // Subtract lower 32 bits: A[31:0] - B[31:0]
    sub_32bit u_sub_low (
        .A      (A[31:0]),
        .B      (B[31:0]),
        .bin    (1'b0),       // initial borrow-in is 0
        .diff   (result[31:0]),
        .bout   (borrow_low)
    );

    // Subtract upper 32 bits: A[63:32] - B[63:32] - borrow_low
    sub_32bit u_sub_high (
        .A      (A[63:32]),
        .B      (B[63:32]),
        .bin    (borrow_low),
        .diff   (result[63:32]),
        .bout   (borrow_high)
    );

    // Overflow detection for 64-bit signed subtraction:
    // Overflow occurs if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 32-bit subtractor with borrow-in and borrow-out (ripple borrow)
module sub_32bit (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        bin,   // borrow input
    output wire [31:0] diff,
    output wire        bout   // borrow output
);
    wire [31:0] b;        // borrow signals between bits
    wire [31:0] B_plus_bin;

    assign B_plus_bin = B + bin; // Add initial borrow-in to B for first stage subtraction

    // Subtraction bit by bit using ripple borrow logic:
    // diff[i] = A[i] ^ B_plus_bin[i] ^ b[i]
    // b[i+1] = (~A[i] & (B_plus_bin[i] | b[i])) | (B_plus_bin[i] & b[i])
    // We unroll these for 32 bits

    assign b[0] = 1'b0; // initial internal borrow is zero (bin already added to B_plus_bin)

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : bit_sub
            wire A_i = A[i];
            wire B_i = B_plus_bin[i];
            wire borrow_in = (i == 0) ? 1'b0 : b[i];

            assign diff[i] = A_i ^ B_i ^ borrow_in;

            // Compute borrow out for this bit unless last bit
            if (i < 31) begin
                assign b[i+1] = (~A_i & (B_i | borrow_in)) | (B_i & borrow_in);
            end
        end
    endgenerate

    assign bout = b[32-1]; // final borrow out is borrow from MSB

endmodule