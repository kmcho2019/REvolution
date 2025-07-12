module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    assign out = (sel == 2'd0) ? in[0] :
                 (sel == 2'd1) ? in[1] :
                 (sel == 2'd2) ? in[2] :
                                 in[3];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Break sel into 3 parts of 2 bits each:
    wire [1:0] sel_l0 = sel[1:0];  // selects within 4-bit groups
    wire [1:0] sel_l1 = sel[3:2];  // selects within groups of 16 bits (4*4)
    wire [1:0] sel_l2 = sel[5:4];  // selects within groups of 64 bits (4*16)
    wire [1:0] sel_l3 = sel[7:6];  // selects which 64-bit quarter

    // Level 0: 64 instances of 4-to-1 mux selecting one bit among 4 bits
    wire [63:0] lvl0_out;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : lvl0_muxes
            Mux4to1 mux4 (
                .in(in[i*4 +: 4]),
                .sel(sel_l0),
                .out(lvl0_out[i])
            );
        end
    endgenerate

    // Level 1: 16 instances of 4-to-1 mux selecting one bit among 4 lvl0 outputs (4*4 =16 bits)
    wire [15:0] lvl1_out;
    generate
        for (i = 0; i < 16; i = i + 1) begin : lvl1_muxes
            Mux4to1 mux4_lvl1 (
                .in(lvl0_out[i*4 +: 4]),
                .sel(sel_l1),
                .out(lvl1_out[i])
            );
        end
    endgenerate

    // Level 2: 4 instances of 4-to-1 mux selecting one bit among 4 lvl1 outputs (4*16 =64 bits)
    wire [3:0] lvl2_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : lvl2_muxes
            Mux4to1 mux4_lvl2 (
                .in(lvl1_out[i*4 +: 4]),
                .sel(sel_l2),
                .out(lvl2_out[i])
            );
        end
    endgenerate

    // Level 3: final 4-to-1 mux selects one bit among 4 lvl2 outputs (4*64=256 bits)
    Mux4to1 mux4_lvl3 (
        .in(lvl2_out),
        .sel(sel_l3),
        .out(out)
    );

endmodule