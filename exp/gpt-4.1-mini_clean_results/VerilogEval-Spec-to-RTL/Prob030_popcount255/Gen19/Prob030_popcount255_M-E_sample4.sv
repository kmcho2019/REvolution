module popcount4 (
    input  [3:0] in,
    output [2:0] out // max count 4 fits in 3 bits
);
    // Simple structural popcount4 using a balanced adder tree
    wire [1:0] sum_l1 [1:0];
    assign sum_l1[0] = in[1:0][0] + in[1:0][1];
    assign sum_l1[1] = in[3:2][0] + in[3:2][1];
    assign out = sum_l1[0] + sum_l1[1];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Pad input to 256 bits by adding one zero LSB bit
    wire [255:0] padded_in = {in, 1'b0};

    // Number of popcount4 blocks at first stage = 256/4 = 64
    // Stage widths: each popcount4 outputs 3-bit count (0..4)
    // Subsequent stages sum groups of 4 counts to reduce level by factor 4
    // At each stage, width of sums increases by ceil(log2(4))=2 bits per stage
    // Start width per element at stage0 = 3 bits
    // Number of stages = ceil(log4(64)) = 3 (since 4^3=64)

    // Stage 0: 64 counts of 3 bits
    // Stage 1: 64/4=16 counts of 3+2=5 bits
    // Stage 2: 16/4=4 counts of 5+2=7 bits
    // Stage 3: 4/4=1 count of 7+2=9 bits, output truncated or capped at 8 bits

    // To implement this, create arrays to store stage sums and generate logic.

    // Stage 0: popcount4 blocks (64 units)
    wire [2:0] stage0 [63:0];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_stage0
            popcount4 u_pop4(
                .in(padded_in[4*i +: 4]),
                .out(stage0[i])
            );
        end
    endgenerate

    // Function to sum 4 inputs of WIDTH bits and output WIDTH+2 bits
    // Implemented as a module to perform addition
    // We'll use a module for adding four numbers with same bit-width

    // Define module to sum 4 inputs of parameter WIDTH bits
    // Output is WIDTH+2 bits because max sum = 4*(2^WIDTH-1) <= 2^(WIDTH+2)-1
endmodule

module sum4 #(
    parameter WIDTH = 3
) (
    input  [WIDTH-1:0] in0,
    input  [WIDTH-1:0] in1,
    input  [WIDTH-1:0] in2,
    input  [WIDTH-1:0] in3,
    output [WIDTH+1:0] out // WIDTH+2 bits
);
    // Sum all four inputs
    assign out = in0 + in1 + in2 + in3;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Pad input to 256 bits by adding one zero LSB bit
    wire [255:0] padded_in = {in, 1'b0};

    // Stage 0: 64 popcount4 outputs of 3 bits each
    wire [2:0] stage0 [63:0];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_stage0
            popcount4 u_pop4(
                .in(padded_in[4*i +: 4]),
                .out(stage0[i])
            );
        end
    endgenerate

    // Stage 1: 16 sums of 4 stage0 elements, each sum output 5 bits (3+2)
    wire [4:0] stage1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_stage1
            sum4 #(.WIDTH(3)) u_sum4_stage1(
                .in0(stage0[4*i]),
                .in1(stage0[4*i+1]),
                .in2(stage0[4*i+2]),
                .in3(stage0[4*i+3]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: 4 sums of 4 stage1 elements, output 7 bits (5+2)
    wire [6:0] stage2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_stage2
            sum4 #(.WIDTH(5)) u_sum4_stage2(
                .in0(stage1[4*i]),
                .in1(stage1[4*i+1]),
                .in2(stage1[4*i+2]),
                .in3(stage1[4*i+3]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: 1 sum of 4 stage2 elements, output 9 bits (7+2)
    wire [8:0] stage3;
    sum4 #(.WIDTH(7)) u_sum4_stage3(
        .in0(stage2[0]),
        .in1(stage2[1]),
        .in2(stage2[2]),
        .in3(stage2[3]),
        .out(stage3)
    );

    // The maximum count is 255, which fits in 8 bits; truncate stage3 output to 8 bits
    assign out = stage3[7:0];
endmodule