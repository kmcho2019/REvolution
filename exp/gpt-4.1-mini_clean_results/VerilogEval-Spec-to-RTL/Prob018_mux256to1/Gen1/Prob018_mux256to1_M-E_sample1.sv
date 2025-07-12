module Mux16to1 (
    input  [15:0] in,
    input  [3:0]  sel,
    output        out
);
    // 16-to-1 mux by indexing the 16-bit vector with 4-bit selector
    assign out = in[sel];
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    wire [15:0] level1_out;

    // Instantiate 16 muxes for each 16-bit chunk
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1_MUXES
            Mux16to1 u_mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Final mux selects one of the 16 outputs from the level1 muxes
    Mux16to1 u_final_mux (
        .in(level1_out),
        .sel(sel[7:4]),
        .out(out)
    );
endmodule