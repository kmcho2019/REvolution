module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // Direct indexed 16-to-1 mux
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0 outputs: 16 wires from 16-to-1 muxes
    wire [15:0] level0_out;

    genvar i;

    // Instantiate 16 Mux16to1 modules, each selecting from 16 bits of 'in' using sel[3:0]
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level0
            Mux16to1 mux_inst (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Final Mux16to1 selects among level0_out using sel[7:4]
    Mux16to1 mux_final (
        .in(level0_out),
        .sel(sel[7:4]),
        .out(out)
    );

endmodule