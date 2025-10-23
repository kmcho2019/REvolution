module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Internal signals for borrow between 16-bit chunks
    wire b1, b2, b3;

    // Instantiate 4 chained 16-bit subtractors with borrow in/out
    // Each subtractor: result_chunk = A_chunk - B_chunk - borrow_in
    // borrow_out asserted if subtraction underflows (i.e., borrow generated)

    sub_16bit chunk0 (
        .A    (A[15:0]),
        .B    (B[15:0]),
        .bin  (1'b0),
        .diff (result[15:0]),
        .bout (b1)
    );

    sub_16bit chunk1 (
        .A    (A[31:16]),
        .B    (B[31:16]),
        .bin  (b1),
        .diff (result[31:16]),
        .bout (b2)
    );

    sub_16bit chunk2 (
        .A    (A[47:32]),
        .B    (B[47:32]),
        .bin  (b2),
        .diff (result[47:32]),
        .bout (b3)
    );

    sub_16bit chunk3 (
        .A    (A[63:48]),
        .B    (B[63:48]),
        .bin  (b3),
        .diff (result[63:48]),
        .bout ()
    );

    // Overflow detection as per problem statement
    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow occurs when signs of A and B differ,
    // and sign of result differs from sign of A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule


// 16-bit subtractor with borrow input and borrow output
module sub_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        bin,    // borrow in
    output wire [15:0] diff,
    output wire        bout    // borrow out
);
    // Perform subtraction with borrow
    // Using A - B - bin = diff
    // borrow out = 1 if A < B + bin
    wire [16:0] temp_sub;

    assign temp_sub = {1'b0, A} - {1'b0, B} - bin;
    assign diff = temp_sub[15:0];
    assign bout = ~temp_sub[16]; 
    // Explanation: If temp_sub is negative, MSB of temp_sub (bit 16) = 1, then borrow out = 1 (i.e., ~1=0 means no borrow),
    // so invert the sign bit to correctly get borrow out.
    // But since temp_sub is unsigned subtraction result, borrow occurs if MSB bit is 1, so borrow out = MSB bit (bit 16) itself.
    // Correcting logic:

    // Correction of borrow logic:
    // If temp_sub[16] = 1 => borrow occurred
    // So assign bout = temp_sub[16];
    // Let's fix that:

endmodule


// Revised sub_16bit with corrected borrow out logic:
module sub_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        bin,    // borrow in
    output wire [15:0] diff,
    output wire        bout    // borrow out
);
    wire [16:0] temp_sub;

    assign temp_sub = {1'b0, A} - {1'b0, B} - bin;
    assign diff = temp_sub[15:0];
    assign bout = temp_sub[16];
endmodule