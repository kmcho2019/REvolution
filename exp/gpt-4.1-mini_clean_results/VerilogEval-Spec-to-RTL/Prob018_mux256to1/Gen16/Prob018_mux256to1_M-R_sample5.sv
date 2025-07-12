module Mux16to1 (
    input  [15:0] in,
    input  [3:0]  sel,
    output        out
);
    // Use direct indexing to select the bit, creating a 16-to-1 mux with continuous assignment
    assign out = in[sel];
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);
    wire [15:0] level1_out;

    // Instantiate 16 16-to-1 muxes with continuous assignments inside Mux16to1
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

    // Final 16-to-1 mux with continuous assignment selecting among the outputs of level 1 muxes
    assign out = level1_out[sel[7:4]];
endmodule