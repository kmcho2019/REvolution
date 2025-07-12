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
    // Build 16-to-1 mux as a balanced two-level tree of 4-to-1 muxes
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
    wire [3:0] sel_low  = sel[3:0];
    wire [3:0] sel_high = sel[7:4];

    genvar i;
    generate
        // Level 1: 16 instances of 16-to-1 muxes, each selecting one bit from 16 bits of 'in' using sel_low
        for (i = 0; i < 16; i = i + 1) begin : level1_muxes
            Mux16to1 mux16_inst (
                .in(in[i*16 +: 16]),
                .sel(sel_low),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: final 16-to-1 mux selects among outputs of level 1 using sel_high
    Mux16to1 mux16_final (
        .in(level1_out),
        .sel(sel_high),
        .out(out)
    );
endmodule