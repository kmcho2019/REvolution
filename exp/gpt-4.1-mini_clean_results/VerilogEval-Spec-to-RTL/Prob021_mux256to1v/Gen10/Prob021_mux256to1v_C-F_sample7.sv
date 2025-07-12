module Mux16to1_4bit (
    input  wire [16*4-1:0] in, // 16 inputs, each 4-bit wide
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    // Select 4-bit slice indexed by sel
    assign out = in[sel*4 +: 4];
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in, // 4 inputs, each 4-bit wide
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,   // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,  // 8-bit select
    output wire [3:0]    out   // 4-bit output
);

    // Stage 1: 16 multiplexers, each 16-to-1 4-bit wide
    // Each mux handles 16 consecutive 4-bit inputs -> 16*4 = 64 bits slice from 'in'
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_MUX16
            wire [63:0] in_slice_16;
            assign in_slice_16 = in[i*64 +: 64]; // 16 * 4 bits = 64 bits slice
            Mux16to1_4bit u_mux16to1 (
                .in(in_slice_16),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Pack stage1_out into a flat bus for stage 2 muxes (4-to-1)
    // stage1_out is 16 elements of 4 bits each = 64 bits total
    wire [63:0] stage1_flat;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_PACK
            assign stage1_flat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    // Stage 2: 4 multiplexers, each 4-to-1 4-bit wide
    // Each mux selects among 4 stage1 outputs (4*4 bits = 16 bits slice)
    wire [3:0] stage2_out [3:0];
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : STAGE2_MUX4
            wire [15:0] in_slice_4;
            assign in_slice_4 = stage1_flat[j*16 +: 16]; // 4 * 4 bits = 16 bits
            Mux4to1_4bit u_mux4to1 (
                .in(in_slice_4),
                .sel(sel[5:4]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Pack stage2_out into a flat bus for final mux
    // 4 elements * 4 bits = 16 bits
    wire [15:0] stage2_flat;
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE2_PACK
            assign stage2_flat[i*4 +: 4] = stage2_out[i];
        end
    endgenerate

    // Stage 3: Final 4-to-1 mux selects among 4 stage2 outputs
    Mux4to1_4bit u_mux4to1_final (
        .in(stage2_flat),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule