module MuxNto1 #(
    parameter N = 2,                // Number of inputs, must be a power of two
    parameter SEL_WIDTH = $clog2(N) // Width of select signal
)(
    input  wire [N-1:0] in,
    input  wire [SEL_WIDTH-1:0] sel,
    output wire out
);
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: 32 mux8to1 instances (8 inputs each), select bits sel[2:0]
    wire [31:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : LEVEL0
            MuxNto1 #(
                .N(8)
            ) u_mux8 (
                .in(in[i*8 +: 8]),
                .sel(sel[2:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 4 mux8to1 instances selecting from level0_out in groups of 8, select bits sel[5:3]
    wire [3:0] level1_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL1
            MuxNto1 #(
                .N(8)
            ) u_mux8 (
                .in(level0_out[i*8 +: 8]),
                .sel(sel[5:3]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 1 mux4to1 instance selecting from level1_out using sel[7:6]
    MuxNto1 #(
        .N(4)
    ) u_mux4 (
        .in(level1_out),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule