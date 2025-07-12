module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    wire [15:0] level1_out;
    wire [3:0]  sel_level1 = sel[3:0];
    wire [3:0]  sel_level2 = sel[7:4];

    // Level 1: sixteen 16-to-1 multiplexers each select one bit out of 16 bits.
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : lvl1_muxes
            Mux16to1 mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel_level1),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: One 16-to-1 mux selecting from the 16 level1 outputs, using sel[7:4]
    Mux16to1 mux_final (
        .in(level1_out),
        .sel(sel_level2),
        .out(out)
    );

endmodule