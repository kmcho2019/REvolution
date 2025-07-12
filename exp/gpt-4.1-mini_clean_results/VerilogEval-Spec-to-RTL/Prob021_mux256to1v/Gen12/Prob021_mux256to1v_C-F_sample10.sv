module Mux4to1_4bit (
    input  wire [15:0] in,    // 4 inputs × 4 bits = 16 bits packed {in3,in2,in1,in0}
    input  wire [1:0]  sel,
    output wire [3:0]  out
);
    // Select 4 bits corresponding to sel index
    assign out = in[sel*4 +: 4];
endmodule

module Mux16to1_4bit (
    input  wire [63:0] in,    // 16 inputs × 4 bits = 64 bits packed {in15,...,in0}
    input  wire [3:0]  sel,
    output wire [3:0]  out
);
    // Select 4 bits corresponding to sel index
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Stage 1: 64 muxes 4-to-1, each selects among 4 inputs (from in)
    wire [3:0] stage1_out [0:15][0:3];
    genvar i, j;

    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1_group
            for (j = 0; j < 4; j = j + 1) begin : stage1_mux
                // Index of mux in range 0..63: i*4 + j
                // Each mux inputs 16 bits from in[(i*64)+(j*16) +: 16]
                // Explanation:
                // - Each i groups 4 muxes
                // - Each mux covers 4 inputs × 4 bits =16 bits
                // Overall: Each group covers 64 inputs ×4 bits =256 bits
                wire [15:0] mux_in = in[(i*64) + (j*16) +: 16];
                Mux4to1_4bit u_mux4to1_stage1 (
                    .in(mux_in),
                    .sel(sel[1:0]),
                    .out(stage1_out[i][j])
                );
            end
        end
    endgenerate

    // Stage 2: 16 muxes 4-to-1, each selects among 4 stage1 outputs
    // stage1_out is 16 groups ×4 outputs = 64 outputs
    wire [3:0] stage2_out [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage2_mux
            // Inputs are stage1_out[i][0..3] each 4-bit
            wire [15:0] mux_in = {
                stage1_out[i][3],
                stage1_out[i][2],
                stage1_out[i][1],
                stage1_out[i][0]
            };
            Mux4to1_4bit u_mux4to1_stage2 (
                .in(mux_in),
                .sel(sel[3:2]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Final Stage: 16-to-1 mux selecting among 16 inputs of 4 bits:
    // We have 16 stage2 outputs. We need to expand these into 16 inputs according to sel[7:4].
    // Since stage2_out is 16 outputs, we can directly use them with sel[7:4].

    // Pack stage2_out into 64-bit vector: {out15,...,out0}
    wire [63:0] final_mux_in;
    generate
        for (i = 0; i < 16; i = i + 1) begin : pack_final
            assign final_mux_in[i*4 +:4] = stage2_out[i];
        end
    endgenerate

    Mux16to1_4bit u_mux16to1_final (
        .in(final_mux_in),
        .sel(sel[7:4]),
        .out(out)
    );

endmodule