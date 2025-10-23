module Mux16to1_4bit #(
    parameter WIDTH = 4
) (
    input  wire [16*WIDTH-1:0] in,  // 16 inputs, WIDTH bits each
    input  wire [3:0]          sel,
    output wire [WIDTH-1:0]    out
);
    // Select WIDTH-bit slice indexed by sel
    assign out = in[sel*WIDTH +: WIDTH];
endmodule

module Mux4to1_4bit #(
    parameter WIDTH = 4
) (
    input  wire [4*WIDTH-1:0] in,   // 4 inputs, WIDTH bits each
    input  wire [1:0]         sel,
    output wire [WIDTH-1:0]   out
);
    assign out = in[sel*WIDTH +: WIDTH];
endmodule

module TopModule (
    input  wire [1023:0] in,   // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,  // 8-bit select signal
    output wire [3:0]    out   // 4-bit output
);
    // Stage 1: 16 x 16-to-1 muxes (select sel[3:0])
    // Each mux covers 16 4-bit inputs -> 16*4=64 bits slice of 'in'
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_MUXES
            wire [63:0] slice_in;
            assign slice_in = in[i*64 +: 64];
            Mux16to1_4bit #(.WIDTH(4)) u_mux16to1 (
                .in(slice_in),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Pack stage1_out into a packed 64-bit vector for stage 2 inputs
    // stage1_out[0] corresponds to bits [3:0], stage1_out[15] to [63:60]
    wire [63:0] stage1_flat;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_PACK
            assign stage1_flat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    // Stage 2: 4 x 4-to-1 muxes (select sel[5:4])
    // Each mux selects among 4 of the stage1 outputs (4*4=16 bits slice)
    wire [3:0] stage2_out [3:0];

    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : STAGE2_MUXES
            wire [15:0] slice_in2;
            assign slice_in2 = stage1_flat[j*16 +: 16];
            Mux4to1_4bit #(.WIDTH(4)) u_mux4to1_stage2 (
                .in(slice_in2),
                .sel(sel[5:4]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Pack stage2_out into 16-bit vector for final stage mux
    wire [15:0] stage2_flat;
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE2_PACK
            assign stage2_flat[i*4 +: 4] = stage2_out[i];
        end
    endgenerate

    // Stage 3: Final 4-to-1 mux (select sel[7:6])
    Mux4to1_4bit #(.WIDTH(4)) u_mux4to1_final (
        .in(stage2_flat),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule