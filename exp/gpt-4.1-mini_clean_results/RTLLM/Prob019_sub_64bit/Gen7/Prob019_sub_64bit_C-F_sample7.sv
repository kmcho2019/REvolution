module sub_16bit_with_borrow (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        borrow_in,
    output wire [15:0] result,
    output wire        borrow_out,
    output wire        propagate,
    output wire        generate
);
    // Compute partial subtraction with borrow_in
    wire [16:0] diff = {1'b0, A} - {1'b0, B} - borrow_in;

    assign result     = diff[15:0];
    assign borrow_out = diff[16];

    // For borrow-lookahead:
    // propagate = block generates no borrow internally for borrow_in=1
    // generate = block generates borrow regardless of borrow_in
    // Using block propagate and generate as:
    // propagate = all bits propagate borrow if borrow_in=1 (i.e., A >= B)
    // generate = borrow generated independently (if A < B)
    // Simplify: 
    // generate = borrow_out when borrow_in=0 (from subtract without borrow_in)
    // But since borrow_out depends on borrow_in, alternatively:
    // We can compute propagate and generate for borrow-lookahead as:
    // propagate = (~A) & B (bitwise), block propagate = &propagate
    // generate  = borrow generated at block level when borrow_in=0
    // For convenience, compute propagate and generate like carry-lookahead adder:

    // Generate and Propagate per bit for borrow:
    // borrow_in propagates through bit if A[i] == B[i]
    wire [15:0] gp = (~A) & B; // borrow propagate per bit
    wire [15:0] gg = (~A) & B; // borrow generate per bit same as propagate here

    // Block propagate: borrow propagates through entire block if no generate in any bit
    // So block propagate: all gp bits are 0 (means no borrow generate)
    // But since gp = (~A) & B, borrow propagates if for all bits, A[i] >= B[i]
    // To get propagate=1 means borrow_in passes through (no borrow generated inside)
    // So block propagate = ~(|gg) for borrow generation
    // But gg=gp here, to avoid confusion let's simplify:

    // Instead, use a simpler approach:
    // borrow_in passes through block if block result with borrow_in=1 causes borrow_out=1 less than borrow_in=0
    // More simply:
    // propagate = (result if borrow_in=0) + 1 == borrow_out when borrow_in=1?

    // Let's simplify with additional subtraction with borrow_in=0 and borrow_in=1 for propagate/generate
    wire borrow_out0 = ({1'b0, A} - {1'b0, B} - 1'b0)[16];
    wire borrow_out1 = ({1'b0, A} - {1'b0, B} - 1'b1)[16];

    assign propagate = ~borrow_out1; // borrow_in passes through if borrow_out with borrow_in=1 is zero
    assign generate  = borrow_out0;  // borrow generated unconditionally if borrow_in=0 causes borrow_out

endmodule


module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    localparam SIGN_BIT = 63;

    // Split inputs into 4 segments of 16-bit
    wire [15:0] A_seg [3:0];
    wire [15:0] B_seg [3:0];
    wire [15:0] R_seg [3:0];

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_seg[0] = B[15:0];
    assign B_seg[1] = B[31:16];
    assign B_seg[2] = B[47:32];
    assign B_seg[3] = B[63:48];

    // For each block, we have propagate and generate signals for borrow-lookahead
    wire propagate [3:0];
    wire generate  [3:0];
    wire borrow    [4:0];

    assign borrow[0] = 1'b0;

    // Instantiate 16-bit subtractors with borrow, propagate, generate
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : gen_sub16
            sub_16bit_with_borrow u_sub16 (
                .A         (A_seg[i]),
                .B         (B_seg[i]),
                .borrow_in (borrow[i]),
                .result    (R_seg[i]),
                .borrow_out(),
                .propagate (propagate[i]),
                .generate  (generate[i])
            );
        end
    endgenerate

    // Borrow-lookahead logic across blocks:
    // borrow[i+1] = generate[i] | (propagate[i] & borrow[i])
    assign borrow[1] = generate[0] | (propagate[0] & borrow[0]);
    assign borrow[2] = generate[1] | (propagate[1] & borrow[1]);
    assign borrow[3] = generate[2] | (propagate[2] & borrow[2]);
    assign borrow[4] = generate[3] | (propagate[3] & borrow[3]);

    // Re-instantiate sub_16bit_with_borrow with corrected borrow_in signals now that borrow chain is known
    // The above initial instantiation does not know borrow_in signals yet.
    // To solve this chicken-and-egg problem, do calculation in two steps:
    // First, calculate generate and propagate assuming borrow_in=0 (or a parallel calculation),
    // Then calculate borrow chain,
    // Then calculate final result with correct borrow_in values.

    // To do this, we must split sub_16bit_with_borrow into two steps or use combinational logic.
    // For clarity and synthesis friendliness, implement a two-level approach here:

    // 1) Compute generate and propagate for each block using a combinational function
    // 2) Compute borrow lookahead signals
    // 3) Compute final subtraction result with correct borrow_in in second step

    // To resolve, implement separate modules or functions:

    // Step 1: Compute generate and propagate for each block
    wire gen [3:0], prop [3:0];
    wire borrow_intermediate [4:0];
    assign borrow_intermediate[0] = 1'b0;

    // Define combinational function to compute generate and propagate for each 16-bit block
    function automatic void gen_prop_16bit;
        input [15:0] A_in, B_in;
        output generate_out, propagate_out;
        reg borrow0, borrow1;
        reg [16:0] diff0, diff1;
        begin
            diff0 = {1'b0, A_in} - {1'b0, B_in} - 1'b0;
            diff1 = {1'b0, A_in} - {1'b0, B_in} - 1'b1;
            borrow0 = diff0[16];
            borrow1 = diff1[16];
            generate_out = borrow0;
            propagate_out = ~borrow1;
        end
    endfunction

    genvar j;
    generate
        for (j=0; j<4; j=j+1) begin : gen_genprop_loop
            wire g, p;
            initial begin
                gen_prop_16bit(A_seg[j], B_seg[j], g, p);
            end
            assign gen[j] = g;
            assign prop[j] = p;
        end
    endgenerate

    // Calculate borrow chain using generate and propagate
    assign borrow_intermediate[1] = gen[0] | (prop[0] & borrow_intermediate[0]);
    assign borrow_intermediate[2] = gen[1] | (prop[1] & borrow_intermediate[1]);
    assign borrow_intermediate[3] = gen[2] | (prop[2] & borrow_intermediate[2]);
    assign borrow_intermediate[4] = gen[3] | (prop[3] & borrow_intermediate[3]);

    // Step 2: Now compute final 16-bit subtraction with actual borrow_in from borrow_intermediate
    // Instantiate four subtractors that take borrow_in from borrow_intermediate[i]

    wire [15:0] final_result [3:0];

    generate
        for (i=0; i<4; i=i+1) begin : gen_final_sub
            sub_16bit_with_borrow_final u_sub16_final (
                .A         (A_seg[i]),
                .B         (B_seg[i]),
                .borrow_in (borrow_intermediate[i]),
                .result    (final_result[i])
            );
        end
    endgenerate

    // Concatenate final results
    assign result = {final_result[3], final_result[2], final_result[1], final_result[0]};

    // Overflow detection: same as before
    assign overflow = (A[SIGN_BIT] != B[SIGN_BIT]) && (result[SIGN_BIT] != A[SIGN_BIT]);

endmodule


// Final 16-bit subtractor for step 2: simple subtraction with given borrow_in (borrow_out ignored)
module sub_16bit_with_borrow_final (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        borrow_in,
    output wire [15:0] result
);
    wire [16:0] diff = {1'b0, A} - {1'b0, B} - borrow_in;
    assign result = diff[15:0];
endmodule