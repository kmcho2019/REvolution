module Mux4to1_4bit (
    input  wire [15:0] in,    // 4 inputs × 4 bits = 16 bits packed {in3,in2,in1,in0}
    input  wire [1:0]  sel,
    output wire [3:0]  out
);
    // Select 4 bits corresponding to sel index
    assign out = in[sel*4 +: 4];
endmodule

module Mux16to1_4bit (
    input  wire [63:0] in,    // 16 inputs × 4 bits = 64 bits packed {in15,...,in0}
    input  wire [3:0]  sel,
    output wire [3:0]  out
);
    // Select 4 bits corresponding to sel index
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,  // 256 inputs × 4 bits
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Level 1: 16 muxes of 16-to-1 each selecting 4-bit inputs from 'in'
    // Each handles 16 inputs * 4 bits = 64 bits
    wire [3:0] level1_out [0:15];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1_16to1
            // Slice 'in' for this block: each block 16 inputs × 4 bits = 64 bits
            wire [63:0] in_slice = in[i*64 +: 64];
            Mux16to1_4bit mux16to1_l1 (
                .in(in_slice),
                .sel(sel[3:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 4 muxes of 4-to-1 selecting among level1 outputs (groups of 4)
    wire [3:0] level2_out [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL2_4to1
            // Inputs: level1_out[i*4 + 0..3], pack as 16 bits
            wire [15:0] mux_in = {
                level1_out[i*4+3],
                level1_out[i*4+2],
                level1_out[i*4+1],
                level1_out[i*4]
            };
            Mux4to1_4bit mux4to1_l2 (
                .in(mux_in),
                .sel(sel[5:4]),
                .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: final 4-to-1 mux selecting among level2 outputs
    wire [15:0] mux_in_final = {
        level2_out[3],
        level2_out[2],
        level2_out[1],
        level2_out[0]
    };
    Mux4to1_4bit mux4to1_l3 (
        .in(mux_in_final),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule