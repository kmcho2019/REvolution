module Mux2to1_2bit (
    input  wire [1:0] a,
    input  wire [1:0] b,
    input  wire       sel,
    output wire [1:0] out
);
    // Simple 2-bit 2-to-1 mux
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // We'll build a hierarchical mux tree from 2-bit mux blocks

    // Stage 0: Create 50 pairs of 2-bit mux outputs
    wire [99:0] stage0;
    genvar i;
    generate
        for (i = 0; i < 50; i = i + 1) begin : stage0_blocks
            Mux2to1_2bit u_mux2bit (
                .a   (a[2*i+1 -: 2]),
                .b   (b[2*i+1 -: 2]),
                .sel (sel),
                .out (stage0[2*i+1 -: 2])
            );
        end
    endgenerate

    // Next stages: combine pairs progressively until full width covered
    // We'll build a function to generate hierarchical mux stages with the same sel

    // Because the width is 100, not a power of two, pad missing bits with zero at top levels
    // We'll combine pairs of 2-bit blocks to form 4-bit blocks at stage1, then 8-bit blocks, etc.

    // Stage 1: combine pairs of 2-bit mux outputs from stage0 into 4-bit mux outputs
    // But since all bits already selected by sel at stage0, next levels just pass the signals through.

    // Actually, since sel is common, and already used to choose a or b at stage0, no further mux needed.
    // Thus, the hierarchical mux tree degenerates to just one stage with 2-bit muxes.

    // We can leave stage0 output as final output:
    assign out = stage0;

endmodule