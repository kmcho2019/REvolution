module TwoToOneMux(
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module Mux16to1_Tree(
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // 16-to-1 mux implemented as a 4-level binary tree of 2-to-1 muxes
    wire [7:0]  level1;
    wire [3:0]  level2;
    wire [1:0]  level3;
    wire        level4;

    genvar i;

    // Level 1: 16 -> 8 muxes, controlled by sel[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_level1
            TwoToOneMux mux (
                .in0(in[2*i]),
                .in1(in[2*i+1]),
                .sel(sel[0]),
                .out(level1[i])
            );
        end
    endgenerate

    // Level 2: 8 -> 4 muxes, controlled by sel[1]
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level2
            TwoToOneMux mux (
                .in0(level1[2*i]),
                .in1(level1[2*i+1]),
                .sel(sel[1]),
                .out(level2[i])
            );
        end
    endgenerate

    // Level 3: 4 -> 2 muxes, controlled by sel[2]
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_level3
            TwoToOneMux mux (
                .in0(level2[2*i]),
                .in1(level2[2*i+1]),
                .sel(sel[2]),
                .out(level3[i])
            );
        end
    endgenerate

    // Level 4: 2 -> 1 mux, controlled by sel[3]
    TwoToOneMux mux_final (
        .in0(level3[0]),
        .in1(level3[1]),
        .sel(sel[3]),
        .out(level4)
    );

    assign out = level4;
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    wire [15:0] chunk_out;

    genvar i;

    // Instantiate 16 16-to-1 mux trees, each selects one bit out of 16 bits, controlled by sel[3:0]
    generate
        for (i = 0; i < 16; i = i + 1) begin : chunks
            Mux16to1_Tree u_mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(chunk_out[i])
            );
        end
    endgenerate

    // Final 16-to-1 mux tree selects one of the 16 chunk outputs by sel[7:4]
    Mux16to1_Tree final_mux (
        .in(chunk_out),
        .sel(sel[7:4]),
        .out(out)
    );
endmodule