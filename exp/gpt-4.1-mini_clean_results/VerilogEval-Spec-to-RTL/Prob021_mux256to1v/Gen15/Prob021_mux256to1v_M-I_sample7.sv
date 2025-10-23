module Mux16to1_4bit #(
    parameter WIDTH = 4
) (
    input  wire [16*WIDTH-1:0] in,  // 16 inputs, WIDTH bits each
    input  wire [3:0]          sel,
    output wire [WIDTH-1:0]    out
);
    assign out = in[sel*WIDTH +: WIDTH];
endmodule

module TopModule (
    input  wire [1023:0] in,   // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,  // 8-bit select signal
    output wire [3:0]    out   // 4-bit output
);

    // Stage 1: 16 x 16-to-1 muxes, each selects 4 bits from 64 bits slice
    // Controlled by sel[3:0]
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_MUXES
            wire [63:0] slice_in;
            assign slice_in = in[i*64 +: 64]; // 16 inputs * 4 bits = 64 bits
            Mux16to1_4bit #(.WIDTH(4)) u_mux16to1 (
                .in(slice_in),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Pack stage1_out into a 64-bit vector for stage 2 input
    wire [63:0] stage1_flat;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_PACK
            assign stage1_flat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    // Stage 2: single 16-to-1 mux selecting among stage1 outputs, controlled by sel[7:4]
    Mux16to1_4bit #(.WIDTH(4)) u_mux16to1_final (
        .in(stage1_flat),
        .sel(sel[7:4]),
        .out(out)
    );

endmodule