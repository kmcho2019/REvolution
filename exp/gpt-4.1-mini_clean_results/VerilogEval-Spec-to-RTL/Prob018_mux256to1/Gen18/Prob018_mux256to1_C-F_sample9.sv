module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Simple direct indexed 4-to-1 mux
    assign out = in[sel];
endmodule

module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // Balanced two-level 16-to-1 mux built from five 4-to-1 muxes
    wire [3:0] level1_out;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : first_stage
            Mux4to1 mux4_inst (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

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

    // Lower 4 bits of sel select bit inside 16-bit chunk
    wire [3:0] sel_low  = sel[3:0];
    // Upper 4 bits select which 16-bit chunk
    wire [3:0] sel_high = sel[7:4];

    genvar i;
    generate
        // 16 instances of 16-to-1 muxes, each selects one bit from a 16-bit slice of in
        for (i = 0; i < 16; i = i + 1) begin : level1_muxes
            Mux16to1 mux16_inst (
                .in(in[i*16 +: 16]),
                .sel(sel_low),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Final 16-to-1 mux selects one of the 16 outputs from level 1 using sel_high
    Mux16to1 mux16_final (
        .in(level1_out),
        .sel(sel_high),
        .out(out)
    );
endmodule