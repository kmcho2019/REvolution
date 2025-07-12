module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    assign out = in[sel];
endmodule

module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // Internally build 16-to-1 mux as tree of 4-to-1 muxes

    wire [3:0] level1_out; // 4 outputs from first layer

    genvar i;
    generate
        // First layer: four 4-to-1 muxes each selects 1 bit from 4 bits of input
        for (i = 0; i < 4; i = i + 1) begin : L1_MUX4
            Mux4to1 mux4_inst (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Second layer: one 4-to-1 mux selects final output from four outputs above
    Mux4to1 mux4_final (
        .in(level1_out),
        .sel(sel[3:2]),
        .out(out)
    );
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    wire [15:0] level1_out;
    wire [3:0] sel_low  = sel[3:0];
    wire [3:0] sel_high = sel[7:4];

    genvar i;
    generate
        // Level 1: 16 Mux16to1 multiplexers selecting bits within 16-bit chunks using sel[3:0]
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1
            Mux16to1 mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel_low),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 1 Mux16to1 multiplexer selecting one of 16 outputs of level1 using sel[7:4]
    Mux16to1 mux_final (
        .in(level1_out),
        .sel(sel_high),
        .out(out)
    );
endmodule