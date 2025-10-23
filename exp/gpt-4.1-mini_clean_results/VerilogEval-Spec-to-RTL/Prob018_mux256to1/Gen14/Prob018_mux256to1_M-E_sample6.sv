module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output reg        out
);
    always @(*) begin
        case (sel)
            2'b00: out = in[0];
            2'b01: out = in[1];
            2'b10: out = in[2];
            2'b11: out = in[3];
            default: out = 1'bx;
        endcase
    end
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: 64 instances of Mux4to1 selecting bits with sel[1:0]
    wire [63:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level0
            Mux4to1 u_mux4_0 (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 16 instances of Mux4to1 selecting bits from level0_out with sel[3:2]
    wire [15:0] level1_out;
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            Mux4to1 u_mux4_1 (
                .in(level0_out[i*4 +: 4]),
                .sel(sel[3:2]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 4 instances of Mux4to1 selecting bits from level1_out with sel[5:4]
    wire [3:0] level2_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2
            Mux4to1 u_mux4_2 (
                .in(level1_out[i*4 +: 4]),
                .sel(sel[5:4]),
                .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: 1 instance of Mux4to1 selecting bit from level2_out with sel[7:6]
    Mux4to1 u_mux4_3 (
        .in(level2_out),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule