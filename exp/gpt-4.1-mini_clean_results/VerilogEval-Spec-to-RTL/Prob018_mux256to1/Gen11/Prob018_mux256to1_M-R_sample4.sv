module Mux16to1 (
    input  [15:0] in,
    input  [3:0]  sel,
    output        out
);
    // Direct indexed continuous assignment for combinational multiplexer
    assign out = in[sel];
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);
    wire [15:0] level1_out;

    genvar idx;
    generate
        // Instantiate sixteen 16-to-1 muxes for each 16-bit slice of input
        for (idx = 0; idx < 16; idx = idx + 1) begin : LEVEL1_MUXES
            Mux16to1 u_mux16 (
                .in(in[idx*16 +: 16]),
                .sel(sel[3:0]),
                .out(level1_out[idx])
            );
        end
    endgenerate

    // Final 16-to-1 mux selecting one of the intermediate outputs
    assign out = level1_out[sel[7:4]];
endmodule