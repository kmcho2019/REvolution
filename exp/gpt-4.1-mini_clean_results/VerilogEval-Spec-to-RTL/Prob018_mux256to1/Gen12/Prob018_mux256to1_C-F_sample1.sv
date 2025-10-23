module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // Direct indexed continuous assignment allows synthesis tools to infer an optimal mux tree
    assign out = in[sel];
endmodule

module Mux256to1 (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    wire [15:0] level1_out;
    genvar i;

    // Instantiate 16 Mux16to1 blocks for 16-bit chunks selected by lower 4 bits of sel
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level1_muxes
            Mux16to1 u_mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Final 16-to-1 mux for the outputs of level1, selected by upper 4 bits of sel
    Mux16to1 final_mux (
        .in(level1_out),
        .sel(sel[7:4]),
        .out(out)
    );
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Top module simply instantiates the hierarchical 256-to-1 mux
    Mux256to1 u_mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );
endmodule