module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    assign out = in[sel];
endmodule

module Mux8to1 (
    input  wire [7:0] in,
    input  wire [2:0] sel,
    output wire       out
);
    // Implement 8-to-1 mux as two levels of 4-to-1 muxes
    wire [1:0] sel_low  = sel[1:0];
    wire       sel_high = sel[2];

    wire [1:0] level1_out;

    // Two 4-to-1 muxes selecting 4 inputs each
    Mux4to1 mux_lower (
        .in(in[3:0]),
        .sel(sel_low),
        .out(level1_out[0])
    );

    Mux4to1 mux_upper (
        .in(in[7:4]),
        .sel(sel_low),
        .out(level1_out[1])
    );

    // Final 2-to-1 mux stage selected by sel[2]
    assign out = level1_out[sel_high];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: 32 Mux8to1 instances selecting 8-bit chunks using sel[2:0]
    wire [31:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : LEVEL0
            Mux8to1 u_mux8 (
                .in(in[i*8 +: 8]),
                .sel(sel[2:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 4 Mux8to1 instances selecting 8-bit groups of level0_out using sel[5:3]
    wire [3:0] level1_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL1
            Mux8to1 u_mux8 (
                .in(level0_out[i*8 +: 8]),
                .sel(sel[5:3]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: final Mux4to1 selecting among 4 outputs of level1_out using sel[7:6]
    Mux4to1 u_mux4 (
        .in(level1_out),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule