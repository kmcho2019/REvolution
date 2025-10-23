module Mux4to1_4bit (
    input  wire [15:0] in,  // 4 inputs × 4 bits = 16 bits total
    input  wire [1:0]  sel,
    output wire [3:0]  out
);
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Stage 1: 64 muxes each selecting 4 inputs (sel[1:0])
    // Each mux inputs: 4 × 4-bit = 16 bits
    wire [3:0] stage1_out [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : stage1
            // Calculate the starting bit index in 'in' for this group of 4 inputs:
            // Each input is 4 bits.
            // Each mux selects 4 consecutive inputs, so 4 * 4 = 16 bits per group.
            // Inputs for mux i: bits [ (i*16) + sel[1:0]*4 +: 4 ]
            wire [15:0] mux_in;
            // Extract the 16 bits corresponding to 4 inputs for this mux
            assign mux_in = in[(i*16) +: 16];
            Mux4to1_4bit u_mux4to1_stage1 (
                .in(mux_in),
                .sel(sel[1:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 16 muxes each selecting 4 of stage1_out outputs (sel[3:2])
    wire [3:0] stage2_out [0:15];
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : stage2
            // Concatenate 4 stage1 outputs: each 4 bits, total 16 bits
            wire [15:0] mux_in;
            assign mux_in = {
                stage1_out[j*4 + 3],
                stage1_out[j*4 + 2],
                stage1_out[j*4 + 1],
                stage1_out[j*4 + 0]
            };
            Mux4to1_4bit u_mux4to1_stage2 (
                .in(mux_in),
                .sel(sel[3:2]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Stage 3: 4 muxes each selecting 4 of stage2_out outputs (sel[5:4])
    wire [3:0] stage3_out [0:3];
    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : stage3
            wire [15:0] mux_in;
            assign mux_in = {
                stage2_out[k*4 + 3],
                stage2_out[k*4 + 2],
                stage2_out[k*4 + 1],
                stage2_out[k*4 + 0]
            };
            Mux4to1_4bit u_mux4to1_stage3 (
                .in(mux_in),
                .sel(sel[5:4]),
                .out(stage3_out[k])
            );
        end
    endgenerate

    // Stage 4 (final): 1 mux selecting 4 of stage3_out outputs (sel[7:6])
    wire [15:0] mux_in_final;
    assign mux_in_final = {
        stage3_out[3],
        stage3_out[2],
        stage3_out[1],
        stage3_out[0]
    };
    Mux4to1_4bit u_mux4to1_final (
        .in(mux_in_final),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule