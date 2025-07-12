module mux2to1 #(
    parameter WIDTH = 1
)(
    input  wire [WIDTH-1:0] d0,
    input  wire [WIDTH-1:0] d1,
    input  wire             sel,
    output wire [WIDTH-1:0] y
);
    assign y = sel ? d1 : d0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1; // after shift by 4 if ctrl[2] is 1
    wire [7:0] stage2; // after shift by 2 if ctrl[1] is 1

    // Rotate right by 4 (same as left rotate by 4 for 8 bits)
    wire [7:0] rotated_by_4 = {in[3:0], in[7:4]};

    // Rotate right by 2 (for stage1 input)
    wire [7:0] rotated_by_2 = {stage1[1:0], stage1[7:2]};

    // Rotate right by 1 (for stage2 input)
    wire [7:0] rotated_by_1 = {stage2[0], stage2[7:1]};

    // Stage 1: Shift by 4 if ctrl[2]
    mux2to1 #(.WIDTH(8)) mux_stage1 (
        .d0(in),
        .d1(rotated_by_4),
        .sel(ctrl[2]),
        .y(stage1)
    );

    // Stage 2: Shift by 2 if ctrl[1]
    mux2to1 #(.WIDTH(8)) mux_stage2 (
        .d0(stage1),
        .d1(rotated_by_2),
        .sel(ctrl[1]),
        .y(stage2)
    );

    // Stage 3: Shift by 1 if ctrl[0]
    mux2to1 #(.WIDTH(8)) mux_stage3 (
        .d0(stage2),
        .d1(rotated_by_1),
        .sel(ctrl[0]),
        .y(out)
    );

endmodule