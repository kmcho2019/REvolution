module Mux8to1 (
    input  wire [7:0] in,
    input  wire [2:0] sel,
    output wire       out
);
    // Simple 8-to-1 mux implemented as direct indexing for synthesis friendliness
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: 32 Mux8to1 muxes selecting one bit from 8 input bits
    wire [31:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : LEVEL0
            Mux8to1 u_mux8_0 (
                .in(in[i*8 +: 8]),
                .sel(sel[2:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 4 Mux8to1 muxes selecting one bit from 8 level0 outputs each
    wire [3:0] level1_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL1
            Mux8to1 u_mux8_1 (
                .in(level0_out[i*8 +: 8]),
                .sel(sel[5:3]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: Final Mux8to1 selecting output from level1 outputs plus padding bits
    // level1_out has only 4 bits, but Mux8to1 requires 8 bits.
    // Pad upper 4 bits with 0. Use sel[7:6] plus zero bit for sel[2:0].
    wire [7:0] level2_in = {4'b0, level1_out};
    wire [2:0] level2_sel = {sel[7:6], 1'b0};
    Mux8to1 u_mux8_final (
        .in(level2_in),
        .sel(level2_sel),
        .out(out)
    );
endmodule