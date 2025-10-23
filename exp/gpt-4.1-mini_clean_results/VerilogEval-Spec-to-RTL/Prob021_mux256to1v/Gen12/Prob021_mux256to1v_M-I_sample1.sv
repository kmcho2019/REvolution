module Mux4to1_4bit (
    input  wire [4*4-1:0] in,  // 4 inputs, each 4-bit wide
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    // Select 4-bit slice indexed by sel
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 0: 64 muxes, each 4-to-1 on sel[1:0]
    // Each mux selects 4 inputs (4*4 bits = 16 bits)
    // Inputs per mux: 4 * 4-bit = 16 bits
    // Each mux covers a 16-bit slice of 'in':
    // Each group corresponds to in[ (idx*16) +: 16 ]
    // idx runs 0..63 (64 muxes)

    wire [3:0] stage0_out [0:63];
    genvar i;

    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE0
            wire [15:0] in_slice = in[i*16 +: 16]; // 4 inputs * 4 bits
            Mux4to1_4bit u_mux4to1_stage0 (
                .in(in_slice),
                .sel(sel[1:0]),
                .out(stage0_out[i])
            );
        end
    endgenerate

    // Stage 1: 16 muxes, each 4-to-1 on sel[3:2]
    // Inputs come from stage0_out, 16 groups of 4 inputs
    // Each input 4 bits, so 4*4 = 16 bits per mux input bus

    wire [3:0] stage1_out [0:15];
    genvar j;

    generate
        for (j = 0; j < 16; j = j + 1) begin : STAGE1
            wire [15:0] stage0_concat = {
                stage0_out[j*4+3],
                stage0_out[j*4+2],
                stage0_out[j*4+1],
                stage0_out[j*4+0]
            };
            Mux4to1_4bit u_mux4to1_stage1 (
                .in(stage0_concat),
                .sel(sel[3:2]),
                .out(stage1_out[j])
            );
        end
    endgenerate

    // Stage 2: 4 muxes, each 4-to-1 on sel[5:4]
    // Inputs come from stage1_out, 4 groups of 4 inputs each

    wire [3:0] stage2_out [0:3];
    genvar k;

    generate
        for (k = 0; k < 4; k = k + 1) begin : STAGE2
            wire [15:0] stage1_concat = {
                stage1_out[k*4+3],
                stage1_out[k*4+2],
                stage1_out[k*4+1],
                stage1_out[k*4+0]
            };
            Mux4to1_4bit u_mux4to1_stage2 (
                .in(stage1_concat),
                .sel(sel[5:4]),
                .out(stage2_out[k])
            );
        end
    endgenerate

    // Stage 3: final mux, 4-to-1 on sel[7:6]
    // Inputs come from stage2_out, 4 inputs each 4 bits wide = 16 bits

    wire [15:0] stage2_concat = {
        stage2_out[3],
        stage2_out[2],
        stage2_out[1],
        stage2_out[0]
    };

    Mux4to1_4bit u_mux4to1_stage3 (
        .in(stage2_concat),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule