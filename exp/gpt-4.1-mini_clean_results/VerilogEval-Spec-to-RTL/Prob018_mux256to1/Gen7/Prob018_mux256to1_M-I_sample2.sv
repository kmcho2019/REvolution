module Mux4to1 (
    input  [3:0] in,
    input  [1:0] sel,
    output       out
);
    assign out = in[sel];
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Level 1: 64 mux4to1 instances selecting 4 bits each using sel[1:0]
    wire [63:0] level1_out;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : LEVEL1
            Mux4to1 u_mux4 (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 16 mux4to1 instances selecting 4 outputs each from level1 using sel[3:2]
    wire [15:0] level2_out;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2
            Mux4to1 u_mux4 (
                .in(level1_out[i*4 +: 4]),
                .sel(sel[3:2]),
                .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: 4 mux4to1 instances selecting 4 outputs each from level2 using sel[5:4]
    wire [3:0] level3_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            Mux4to1 u_mux4 (
                .in(level2_out[i*4 +: 4]),
                .sel(sel[5:4]),
                .out(level3_out[i])
            );
        end
    endgenerate

    // Level 4: final mux4to1 selecting one of 4 outputs using sel[7:6]
    Mux4to1 u_final_mux (
        .in(level3_out),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule