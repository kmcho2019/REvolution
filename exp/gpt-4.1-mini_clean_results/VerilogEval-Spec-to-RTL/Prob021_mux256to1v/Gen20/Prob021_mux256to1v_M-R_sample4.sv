module Mux4to1_4bit (
    input  wire [15:0] in,   // 4 inputs concatenated (4 bits each)
    input  wire [1:0]  sel,
    output wire [3:0]  out
);
    // Using continuous assignment with multiplexing expression for clarity and synthesis efficiency
    assign out = (sel == 2'd0) ? in[ 3: 0] :
                 (sel == 2'd1) ? in[ 7: 4] :
                 (sel == 2'd2) ? in[11: 8] :
                                 in[15:12];
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 1: 64 x 4-to-1 muxes selecting from 256 inputs (4 bits each), sel[1:0]
    wire [3:0] stage1_out [63:0];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE1
            wire [15:0] in_slice = in[i*16 +: 16]; // 4 inputs * 4 bits
            Mux4to1_4bit mux_stage1 (
                .in(in_slice),
                .sel(sel[1:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 16 x 4-to-1 muxes selecting from stage1_out, sel[3:2]
    wire [3:0] stage2_out [15:0];
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : STAGE2
            // Concatenate 4 stage1 outputs for this mux (each 4-bit)
            wire [15:0] in_stage2 = {
                stage1_out[j*4 + 3],
                stage1_out[j*4 + 2],
                stage1_out[j*4 + 1],
                stage1_out[j*4 + 0]
            };
            Mux4to1_4bit mux_stage2 (
                .in(in_stage2),
                .sel(sel[3:2]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Stage 3: 4 x 4-to-1 muxes selecting from stage2_out, sel[5:4]
    wire [3:0] stage3_out [3:0];
    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : STAGE3
            wire [15:0] in_stage3 = {
                stage2_out[k*4 + 3],
                stage2_out[k*4 + 2],
                stage2_out[k*4 + 1],
                stage2_out[k*4 + 0]
            };
            Mux4to1_4bit mux_stage3 (
                .in(in_stage3),
                .sel(sel[5:4]),
                .out(stage3_out[k])
            );
        end
    endgenerate

    // Stage 4: Final 4-to-1 mux selecting from stage3_out, sel[7:6]
    wire [15:0] in_stage4 = {
        stage3_out[3],
        stage3_out[2],
        stage3_out[1],
        stage3_out[0]
    };
    Mux4to1_4bit mux_stage4 (
        .in(in_stage4),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule