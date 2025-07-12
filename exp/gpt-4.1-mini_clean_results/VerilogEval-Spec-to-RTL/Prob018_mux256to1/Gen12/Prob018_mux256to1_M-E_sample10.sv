module Mux2to1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // We'll create wires for intermediate mux outputs at each level
    // Level 0 inputs are the bits of 'in'
    // At each subsequent level, we halve the number of signals by muxing pairs
    
    wire [127:0] level1;
    genvar i;
    generate
        for (i=0; i<128; i=i+1) begin : level1_muxes
            Mux2to1 mux2(
                .in0(in[i*2]),
                .in1(in[i*2+1]),
                .sel(sel[0]),
                .out(level1[i])
            );
        end
    endgenerate

    wire [63:0] level2;
    generate
        for (i=0; i<64; i=i+1) begin : level2_muxes
            Mux2to1 mux2(
                .in0(level1[i*2]),
                .in1(level1[i*2+1]),
                .sel(sel[1]),
                .out(level2[i])
            );
        end
    endgenerate

    wire [31:0] level3;
    generate
        for (i=0; i<32; i=i+1) begin : level3_muxes
            Mux2to1 mux2(
                .in0(level2[i*2]),
                .in1(level2[i*2+1]),
                .sel(sel[2]),
                .out(level3[i])
            );
        end
    endgenerate

    wire [15:0] level4;
    generate
        for (i=0; i<16; i=i+1) begin : level4_muxes
            Mux2to1 mux2(
                .in0(level3[i*2]),
                .in1(level3[i*2+1]),
                .sel(sel[3]),
                .out(level4[i])
            );
        end
    endgenerate

    wire [7:0] level5;
    generate
        for (i=0; i<8; i=i+1) begin : level5_muxes
            Mux2to1 mux2(
                .in0(level4[i*2]),
                .in1(level4[i*2+1]),
                .sel(sel[4]),
                .out(level5[i])
            );
        end
    endgenerate

    wire [3:0] level6;
    generate
        for (i=0; i<4; i=i+1) begin : level6_muxes
            Mux2to1 mux2(
                .in0(level5[i*2]),
                .in1(level5[i*2+1]),
                .sel(sel[5]),
                .out(level6[i])
            );
        end
    endgenerate

    wire [1:0] level7;
    generate
        for (i=0; i<2; i=i+1) begin : level7_muxes
            Mux2to1 mux2(
                .in0(level6[i*2]),
                .in1(level6[i*2+1]),
                .sel(sel[6]),
                .out(level7[i])
            );
        end
    endgenerate

    // Final mux level
    Mux2to1 mux_final(
        .in0(level7[0]),
        .in1(level7[1]),
        .sel(sel[7]),
        .out(out)
    );

endmodule