module Mux16to1_4bit (
    input  wire [16*4-1:0] in, // 16 inputs, each 4-bit wide concatenated
    input  wire [3:0]      sel,
    output reg  [3:0]      out
);
    always @(*) begin
        case (sel)
            4'd0 : out = in[  0 +: 4];
            4'd1 : out = in[  4 +: 4];
            4'd2 : out = in[  8 +: 4];
            4'd3 : out = in[ 12 +: 4];
            4'd4 : out = in[ 16 +: 4];
            4'd5 : out = in[ 20 +: 4];
            4'd6 : out = in[ 24 +: 4];
            4'd7 : out = in[ 28 +: 4];
            4'd8 : out = in[ 32 +: 4];
            4'd9 : out = in[ 36 +: 4];
            4'd10: out = in[ 40 +: 4];
            4'd11: out = in[ 44 +: 4];
            4'd12: out = in[ 48 +: 4];
            4'd13: out = in[ 52 +: 4];
            4'd14: out = in[ 56 +: 4];
            4'd15: out = in[ 60 +: 4];
            default: out = 4'b0000;
        endcase
    end
endmodule

module TopModule (
    input  wire [1023:0] in,   // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,  // 8-bit select
    output wire [3:0]    out   // 4-bit output
);

    // Stage 1: 16 multiplexers, each 16-to-1 4-bit wide mux,
    // select among 16 inputs (64 bits) using sel[3:0]
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_MUX16
            wire [63:0] in_slice_16 = in[i*64 +: 64]; // 16 * 4 bits = 64 bits slice
            Mux16to1_4bit u_mux16to1 (
                .in(in_slice_16),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Flatten stage1_out into one bus for stage 2 input
    wire [63:0] stage1_flat;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_PACK
            assign stage1_flat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    // Stage 2: Final 16-to-1 4-bit mux selects output based on sel[7:4]
    Mux16to1_4bit u_mux16to1_final (
        .in(stage1_flat),
        .sel(sel[7:4]),
        .out(out)
    );

endmodule