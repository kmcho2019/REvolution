module MuxNto1_4bit #(
    parameter N = 16  // Number of inputs (must be a power of two)
) (
    input  wire [N*4-1:0] in,  // N inputs, each 4-bit
    input  wire [$clog2(N)-1:0] sel,
    output wire [3:0] out
);
    // Select the 4-bit slice at index sel
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,  // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel, // 8-bit select
    output wire [3:0]    out
);
    // Stage widths and counts:
    // Stage 1: 16 muxes of 16-to-1 (16*16=256 inputs total)
    // Stage 2: 4 muxes of 4-to-1 (select among stage1 outputs)
    // Stage 3: 1 mux of 4-to-1 (final output)

    // Stage 1 outputs (16 muxes, each 4-bit output)
    wire [4*16-1:0] stage1_out; // concatenated 16 4-bit outputs

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_stage1
            // Slice 64 bits (16*4) from 'in' for each 16-to-1 mux
            wire [16*4-1:0] in_slice = in[i*64 +: 64];
            MuxNto1_4bit #(.N(16)) mux16to1 (
                .in(in_slice),
                .sel(sel[3:0]),
                .out(stage1_out[i*4 +: 4])
            );
        end
    endgenerate

    // Stage 2 outputs (4 muxes of 4-to-1)
    wire [4*4-1:0] stage2_out; // concatenated 4 4-bit outputs

    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_stage2
            // Each 4-to-1 mux selects among 4 of the stage1 4-bit outputs
            wire [4*4-1:0] in_slice = stage1_out[i*16 +: 16];
            // 16 = 4*4 bits, where each input is 4 bits
            MuxNto1_4bit #(.N(4)) mux4to1_stage2 (
                .in(in_slice),
                .sel(sel[5:4]),
                .out(stage2_out[i*4 +:4])
            );
        end
    endgenerate

    // Stage 3 final mux (4-to-1) selecting among stage2 outputs
    MuxNto1_4bit #(.N(4)) mux4to1_stage3 (
        .in(stage2_out),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule