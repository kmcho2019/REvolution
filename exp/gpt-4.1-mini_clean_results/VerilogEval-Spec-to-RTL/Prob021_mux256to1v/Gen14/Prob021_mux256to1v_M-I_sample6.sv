module Mux4to1_4bit (
    input  wire [4*4-1:0] in, // 4 inputs, each 4-bit wide
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,  // 256 inputs * 4 bits each = 1024 bits
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 1: 64 x 4-to-1 muxes selected by sel[1:0]
    // Each mux selects among 4 inputs (4 bits each)
    // Input index layout: inputs are 4 bits each; total 256 inputs
    // For stage 1 mux #i: inputs at indices [i*4*4 + offset*4 +:4], offset=0..3
    wire [3:0] stage1_out [0:63];
    genvar i, j;

    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE1
            wire [15:0] mux_in; // 4 inputs * 4 bits = 16 bits
            for (j = 0; j < 4; j = j + 1) begin : IN_SLICE
                // Each 4-bit input is at bit ( (i*4 + j)*4 ) to ( (i*4 + j)*4 + 3 )
                assign mux_in[j*4 +:4] = in[((i*4 + j)*4) +:4];
            end
            Mux4to1_4bit u_mux4to1_stage1 (
                .in(mux_in),
                .sel(sel[1:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 16 x 4-to-1 muxes selected by sel[3:2]
    // Inputs come from stage1_out
    // Each mux selects among 4 stage1 outputs
    wire [3:0] stage2_out [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE2
            wire [15:0] mux_in;
            for (j = 0; j < 4; j = j + 1) begin : IN_SLICE
                assign mux_in[j*4 +:4] = stage1_out[i*4 + j];
            end
            Mux4to1_4bit u_mux4to1_stage2 (
                .in(mux_in),
                .sel(sel[3:2]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Stage 3: 4 x 4-to-1 muxes selected by sel[5:4]
    // Inputs come from stage2_out
    wire [3:0] stage3_out [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE3
            wire [15:0] mux_in;
            for (j = 0; j < 4; j = j + 1) begin : IN_SLICE
                assign mux_in[j*4 +:4] = stage2_out[i*4 + j];
            end
            Mux4to1_4bit u_mux4to1_stage3 (
                .in(mux_in),
                .sel(sel[5:4]),
                .out(stage3_out[i])
            );
        end
    endgenerate

    // Stage 4: final 4-to-1 mux selected by sel[7:6]
    wire [15:0] final_in;
    generate
        for (j = 0; j < 4; j = j + 1) begin : FINAL_IN_SLICE
            assign final_in[j*4 +:4] = stage3_out[j];
        end
    endgenerate

    Mux4to1_4bit u_mux4to1_final (
        .in(final_in),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule