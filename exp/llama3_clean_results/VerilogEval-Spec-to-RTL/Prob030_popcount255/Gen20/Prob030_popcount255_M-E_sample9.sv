// Module to compute population count using LUT
module PopulationCountLUT(
    input [7:0] in,
    output [7:0] out
);
    // Pre-computed LUT for population counts of 8-bit values
    reg [7:0] lut[256];
    initial begin
        for (int i = 0; i < 256; i++) begin
            lut[i] = $countones(i);
        end
    end

    assign out = lut[in];
endmodule

// Module for binary tree reduction node
module BinaryTreeNode(
    input [7:0] in0,
    input [7:0] in1,
    output [8:0] out
);
    assign out = in0 + in1;
endmodule

// Top-level module for population count
module TopModule(
    input [254:0] in,
    output [7:0] out
);
    // Divide the input into 32 segments (31 segments of 8 bits, 1 segment of 7 bits)
    wire [7:0] segment [31:0];

    // Assign the segments
    genvar i;
    for (i = 0; i < 31; i++) begin
        assign segment[i] = in[(i*8)+7:i*8];
    end
    assign segment[31] = {1'b0, in[254:248]};

    // Population counts for each segment using LUT
    wire [7:0] segment_count [31:0];

    // Instantiate PopulationCountLUT for each segment
    for (genvar i = 0; i < 32; i++) begin
        PopulationCountLUT pcl(
            .in(segment[i]),
            .out(segment_count[i])
        );
    end

    // Binary tree reduction
    wire [8:0] stage1_sum [15:0];
    for (genvar i = 0; i < 16; i++) begin
        BinaryTreeNode btn(
            .in0(segment_count[i*2]),
            .in1(segment_count[i*2+1]),
            .out(stage1_sum[i])
        );
    end

    wire [9:0] stage2_sum [7:0];
    for (genvar i = 0; i < 8; i++) begin
        BinaryTreeNode btn(
            .in0(stage1_sum[i*2][7:0]),
            .in1(stage1_sum[i*2+1][7:0]),
            .out(stage2_sum[i])
        );
    end

    wire [10:0] stage3_sum [3:0];
    for (genvar i = 0; i < 4; i++) begin
        BinaryTreeNode btn(
            .in0(stage2_sum[i*2][8:0]),
            .in1(stage2_sum[i*2+1][8:0]),
            .out(stage3_sum[i])
        );
    end

    wire [11:0] stage4_sum [1:0];
    for (genvar i = 0; i < 2; i++) begin
        BinaryTreeNode btn(
            .in0(stage3_sum[i*2][9:0]),
            .in1(stage3_sum[i*2+1][9:0]),
            .out(stage4_sum[i])
        );
    end

    wire [12:0] final_sum;
    BinaryTreeNode btn(
        .in0(stage4_sum[0][10:0]),
        .in1(stage4_sum[1][10:0]),
        .out(final_sum)
    );

    // Assign the output
    assign out = final_sum[7:0];
endmodule