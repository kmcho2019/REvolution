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
    // Split inputs into four 16-bit segments
    wire [15:0] A_seg [3:0];
    wire [15:0] B_seg [3:0];
    wire [15:0] R_seg [3:0];
    wire        borrow [4:0]; // borrow chain

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_seg[0] = B[15:0];
    assign B_seg[1] = B[31:16];
    assign B_seg[2] = B[47:32];
    assign B_seg[3] = B[63:48];

    assign borrow[0] = 1'b0; // No initial borrow-in

    // Instantiate 4 chained 16-bit subtractors
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

    // Overflow detection based on sign bits of A, B and result
    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow if sign of A and B differ and sign of result is different from A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule