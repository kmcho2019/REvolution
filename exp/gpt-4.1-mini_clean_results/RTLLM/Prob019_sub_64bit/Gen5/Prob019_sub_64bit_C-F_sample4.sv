module sub_16bit_with_borrow (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        borrow_in,
    output wire [15:0] result,
    output wire        borrow_out
);
    // Perform 17-bit subtraction to detect borrow:
    // result = A - B - borrow_in
    wire [16:0] diff = {1'b0, A} - {1'b0, B} - borrow_in;

    assign result     = diff[15:0];
    assign borrow_out = diff[16]; // borrow_out is 1 if subtraction borrowed from higher bit
endmodule


module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    localparam SIGN_BIT = 63;

    // Split inputs into four 16-bit segments
    wire [15:0] A_seg [3:0];
    wire [15:0] B_seg [3:0];
    wire [15:0] R_seg [3:0];
    wire        borrow [4:0];

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_seg[0] = B[15:0];
    assign B_seg[1] = B[31:16];
    assign B_seg[2] = B[47:32];
    assign B_seg[3] = B[63:48];

    assign borrow[0] = 1'b0;

    // Instantiate 4 chained 16-bit subtractors using two's complement subtraction internally
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : gen_sub16
            sub_16bit_with_borrow u_sub16 (
                .A         (A_seg[i]),
                .B         (B_seg[i]),
                .borrow_in (borrow[i]),
                .result    (R_seg[i]),
                .borrow_out(borrow[i+1])
            );
        end
    endgenerate

    // Combine results into 64-bit output
    assign result = {R_seg[3], R_seg[2], R_seg[1], R_seg[0]};

    // Overflow detection:
    // Overflow occurs when sign of A != sign of B and sign of result != sign of A
    assign overflow = (A[SIGN_BIT] != B[SIGN_BIT]) && (result[SIGN_BIT] != A[SIGN_BIT]);

endmodule