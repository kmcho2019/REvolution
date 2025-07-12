// Module to count the number of ones in an 8-bit segment
module SegmentCounter(
    input [7:0] in,
    output [4:0] out // Reduced width based on max possible ones in 8-bit segment
);
    assign out = $countones(in);
endmodule

// Module to calculate the sum of two segment counts
module HalfGroupSum(
    input [4:0] a,
    input [4:0] b,
    output [5:0] out
);
    assign out = a + b;
endmodule

// Module to calculate the sum of four segment counts using a balanced tree
module GroupSum(
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    output [6:0] out
);
    wire [5:0] sum1, sum2;
    HalfGroupSum hg1(.a(a), .b(b), .out(sum1));
    HalfGroupSum hg2(.c(c), .d(d), .out(sum2));
    assign out = sum1 + sum2;
endmodule

// Top-level module for population count
module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input into 32 segments of 8 bits
    wire [7:0] segment [31:0];

    // Assign the segments
    genvar i;
    for (i = 0; i < 32; i++) begin
        if (i == 31) begin
            assign segment[i] = {1'b0, in[254:248]};
        end else begin
            assign segment[i] = in[(i*8)+7:i*8];
        end
    end

    // Population counts for each segment
    wire [4:0] segment_count [31:0];

    // Instantiate SegmentCounter for each segment
    for (genvar i = 0; i < 32; i++) begin
        SegmentCounter sc(
           .in(segment[i]),
           .out(segment_count[i])
        );
    end

    // Group the segments into 8 groups of 4 segments using a balanced adder tree
    wire [6:0] group_sum [7:0];

    // Instantiate GroupSum for each group
    for (genvar i = 0; i < 8; i++) begin
        GroupSum gs(
           .a(segment_count[i*4]),
           .b(segment_count[i*4+1]),
           .c(segment_count[i*4+2]),
           .d(segment_count[i*4+3]),
           .out(group_sum[i])
        );
    end

    // Final population count using a balanced adder tree
    wire [7:0] count;

    // Level 1: Sum pairs
    wire [7:0] sum1, sum2, sum3, sum4;
    assign sum1 = group_sum[0] + group_sum[1];
    assign sum2 = group_sum[2] + group_sum[3];
    assign sum3 = group_sum[4] + group_sum[5];
    assign sum4 = group_sum[6] + group_sum[7];

    // Level 2: Sum pairs of sums
    wire [8:0] sum12, sum34;
    assign sum12 = sum1 + sum2;
    assign sum34 = sum3 + sum4;

    // Final sum
    assign count = sum12 + sum34;

    // Assign the output
    assign out = count[7:0]; // Ensure 8-bit output

endmodule