module Mux8to1 (
    input  [7:0] in,
    input  [2:0] sel,
    output      out
);
    assign out = in[sel];
endmodule

module Mux4to1 (
    input  [3:0] in,
    input  [1:0] sel,
    output      out
);
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: 32 instances of 8-to-1 mux selecting bits within 8-bit chunks using sel[2:0]
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

    // Level 1: 4 instances of 8-to-1 mux selecting among 8 outputs of level0 using sel[5:3]
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

    // Level 2: 1 instance of 4-to-1 mux selecting among 4 outputs of level1 using sel[7:6]
    Mux4to1 u_mux4 (
        .in(level1_out),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule