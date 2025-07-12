module Mux4to1 #(
    parameter WIDTH = 4
) (
    input  wire [4*WIDTH-1:0] in, // 4 inputs of WIDTH bits concatenated
    input  wire [1:0]         sel,
    output wire [WIDTH-1:0]   out
);
    assign out = in[sel*WIDTH +: WIDTH];
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 1: 64 x 4-to-1 muxes, selecting among groups of 4 inputs (sel[1:0])
    // Each mux selects 4 inputs of 4 bits = 16 bits from 'in'
    // Total inputs = 256 inputs * 4 bits = 1024 bits

    // Generate wires for stage 1 outputs: 64 outputs, each 4 bits
    wire [3:0] stage1_out [0:63];

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE1
            // Each mux inputs 4 inputs * 4 bits = 16 bits
            // Input slice start bit for the mux's 0th input:
            // Each input block of 4 bits: input index = i*4 + offset_in_0to3
            // So for input group i, inputs at:
            // (i*4 + 0)*4 = i*16, then next inputs every 4 bits
            wire [15:0] in_slice;
            assign in_slice = in[(i*16) +: 16]; // 4 inputs * 4 bits

            Mux4to1 #(.WIDTH(4)) mux4to1_stage1 (
                .in(in_slice),
                .sel(sel[1:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 16 x 4-to-1 muxes selecting among 4 stage1 outputs (sel[3:2])
    // Each mux inputs 4 * 4 bits = 16 bits
    wire [3:0] stage2_out [0:15];

    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : STAGE2
            wire [15:0] in_stage2;
            // Concatenate 4 stage1 outputs: stage1_out[4*j + k] with k=0..3
            assign in_stage2 = {
                stage1_out[j*4 + 3],
                stage1_out[j*4 + 2],
                stage1_out[j*4 + 1],
                stage1_out[j*4 + 0]
            };
            Mux4to1 #(.WIDTH(4)) mux4to1_stage2 (
                .in(in_stage2),
                .sel(sel[3:2]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Stage 3: 4 x 4-to-1 muxes selecting among 4 stage2 outputs (sel[5:4])
    wire [3:0] stage3_out [0:3];

    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : STAGE3
            wire [15:0] in_stage3;
            // Concatenate 4 stage2 outputs
            assign in_stage3 = {
                stage2_out[k*4 + 3],
                stage2_out[k*4 + 2],
                stage2_out[k*4 + 1],
                stage2_out[k*4 + 0]
            };
            Mux4to1 #(.WIDTH(4)) mux4to1_stage3 (
                .in(in_stage3),
                .sel(sel[5:4]),
                .out(stage3_out[k])
            );
        end
    endgenerate

    // Stage 4 (final): 4-to-1 mux selecting among 4 stage3 outputs (sel[7:6])
    wire [15:0] in_stage4;
    assign in_stage4 = {
        stage3_out[3],
        stage3_out[2],
        stage3_out[1],
        stage3_out[0]
    };

    Mux4to1 #(.WIDTH(4)) mux4to1_stage4 (
        .in(in_stage4),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule