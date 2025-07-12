module Mux16to1_4bit (
    input  wire [16*4-1:0] in, // 16 inputs, each 4-bit wide
    input  wire [3:0]      sel,
    output reg  [3:0]      out
);
    integer idx;
    always @(*) begin
        case (sel)
            4'd0: out = in[4*0 +: 4];
            4'd1: out = in[4*1 +: 4];
            4'd2: out = in[4*2 +: 4];
            4'd3: out = in[4*3 +: 4];
            4'd4: out = in[4*4 +: 4];
            4'd5: out = in[4*5 +: 4];
            4'd6: out = in[4*6 +: 4];
            4'd7: out = in[4*7 +: 4];
            4'd8: out = in[4*8 +: 4];
            4'd9: out = in[4*9 +: 4];
            4'd10: out = in[4*10 +: 4];
            4'd11: out = in[4*11 +: 4];
            4'd12: out = in[4*12 +: 4];
            4'd13: out = in[4*13 +: 4];
            4'd14: out = in[4*14 +: 4];
            4'd15: out = in[4*15 +: 4];
            default: out = 4'b0000;
        endcase
    end
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in, // 4 inputs, each 4-bit wide
    input  wire [1:0]     sel,
    output reg  [3:0]     out
);
    always @(*) begin
        case (sel)
            2'd0: out = in[4*0 +: 4];
            2'd1: out = in[4*1 +: 4];
            2'd2: out = in[4*2 +: 4];
            2'd3: out = in[4*3 +: 4];
            default: out = 4'b0000;
        endcase
    end
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 1: 16 instances of 16-to-1 mux selecting sel[3:0]
    // Each mux covers 64 bits (16x4)
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1
            wire [63:0] in_slice = in[i*64 +: 64];
            Mux16to1_4bit mux16to1_inst (
                .in(in_slice),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 4 muxes of 4-to-1 selecting sel[5:4]
    wire [3:0] stage2_out [3:0];

    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : STAGE2
            wire [15:0] stage1_concat = {
                stage1_out[j*4 + 3],
                stage1_out[j*4 + 2],
                stage1_out[j*4 + 1],
                stage1_out[j*4 + 0]
            };
            Mux4to1_4bit mux4to1_stage2_inst (
                .in(stage1_concat),
                .sel(sel[5:4]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Stage 3: final 4-to-1 mux selecting sel[7:6]
    wire [15:0] stage2_concat = {
        stage2_out[3],
        stage2_out[2],
        stage2_out[1],
        stage2_out[0]
    };

    Mux4to1_4bit mux4to1_final_inst (
        .in(stage2_concat),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule