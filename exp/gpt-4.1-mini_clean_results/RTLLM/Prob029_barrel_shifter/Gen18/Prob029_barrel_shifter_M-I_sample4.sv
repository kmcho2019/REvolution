module mux8X2 #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] in0,
    input  wire [WIDTH-1:0] in1,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] in,
    input  wire [2:0]       ctrl,
    output wire [WIDTH-1:0] out
);

    // Rotate left by 4 bits if ctrl[2] set
    wire [WIDTH-1:0] rot4 = {in[WIDTH-5:0], in[WIDTH-1:WIDTH-4]};
    wire [WIDTH-1:0] stage1;
    mux8X2 #(.WIDTH(WIDTH)) mux_stage1 (
        .in0(in),
        .in1(rot4),
        .sel(ctrl[2]),
        .out(stage1)
    );

    // Rotate left by 2 bits if ctrl[1] set
    wire [WIDTH-1:0] rot2 = {stage1[WIDTH-3:0], stage1[WIDTH-1:WIDTH-2]};
    wire [WIDTH-1:0] stage2;
    mux8X2 #(.WIDTH(WIDTH)) mux_stage2 (
        .in0(stage1),
        .in1(rot2),
        .sel(ctrl[1]),
        .out(stage2)
    );

    // Rotate left by 1 bit if ctrl[0] set
    wire [WIDTH-1:0] rot1 = {stage2[WIDTH-2:0], stage2[WIDTH-1]};
    mux8X2 #(.WIDTH(WIDTH)) mux_stage3 (
        .in0(stage2),
        .in1(rot1),
        .sel(ctrl[0]),
        .out(out)
    );

endmodule