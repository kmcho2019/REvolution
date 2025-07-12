// 2-to-1 multiplexer for WIDTH-bit vectors
module mux2X1 #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] in0,
    input  wire [WIDTH-1:0] in1,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Rotate left by 4 bits
    // For 8-bit: bits [3:0] become MSBs, bits [7:4] become LSBs
    wire [7:0] rot4 = {in[3:0], in[7:4]};

    wire [7:0] stage1;
    mux2X1 #(.WIDTH(8)) mux_stage1 (
        .in0(in),
        .in1(rot4),
        .sel(ctrl[2]),
        .out(stage1)
    );

    // Rotate left by 2 bits
    // For 8-bit: bits [5:0] become MSBs, bits [7:6] become LSBs
    wire [7:0] rot2 = {stage1[5:0], stage1[7:6]};

    wire [7:0] stage2;
    mux2X1 #(.WIDTH(8)) mux_stage2 (
        .in0(stage1),
        .in1(rot2),
        .sel(ctrl[1]),
        .out(stage2)
    );

    // Rotate left by 1 bit
    // For 8-bit: bits [6:0] become MSBs, bit [7] becomes LSB
    wire [7:0] rot1 = {stage2[6:0], stage2[7]};

    mux2X1 #(.WIDTH(8)) mux_stage3 (
        .in0(stage2),
        .in1(rot1),
        .sel(ctrl[0]),
        .out(out)
    );

endmodule