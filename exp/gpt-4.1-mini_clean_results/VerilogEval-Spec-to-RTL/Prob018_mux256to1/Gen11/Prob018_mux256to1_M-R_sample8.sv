module Mux16to1 (
    input  [15:0] in,
    input  [3:0]  sel,
    output        out
);
    // Continuous assignment selecting the bit indexed by sel
    assign out = in[sel];
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);
    wire [15:0] level1_out;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1_MUXES
            // Each 16-to-1 mux selects a bit from a 16-bit slice using sel[3:0]
            Mux16to1 u_mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // The top-level mux selects one bit from the 16 intermediate outputs using sel[7:4]
    assign out = level1_out[sel[7:4]];

endmodule