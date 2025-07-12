module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Simple 4-to-1 mux using direct indexing for efficient synthesis
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: 64 Mux4to1 modules selecting from in using sel[1:0]
    wire [63:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level0
            Mux4to1 mux0 (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 16 Mux4to1 modules selecting from level0_out using sel[3:2]
    wire [15:0] level1_out;
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            Mux4to1 mux1 (
                .in(level0_out[i*4 +: 4]),
                .sel(sel[3:2]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 4 Mux4to1 modules selecting from level1_out using sel[5:4]
    wire [3:0] level2_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2
            Mux4to1 mux2 (
                .in(level1_out[i*4 +: 4]),
                .sel(sel[5:4]),
                .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: final selection directly using sel[7:6] without a Mux4to1 instance
    assign out = level2_out[sel[7:6]];
endmodule