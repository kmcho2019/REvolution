// Module to count the number of ones in an 8-bit segment
module SegmentCounter(
    input [7:0] in,
    output [7:0] out
);
    assign out = $countones(in);
endmodule

// Recursive adder module
module RecursiveAdder(
    input [7:0] a,
    input [7:0] b,
    output [8:0] out
);
    assign out = {1'b0, a} + {1'b0, b};
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
    wire [7:0] segment_count [31:0];

    // Instantiate SegmentCounter for each segment
    for (genvar i = 0; i < 32; i++) begin
        SegmentCounter sc(
         .in(segment[i]),
         .out(segment_count[i])
        );
    end

    // Recursive adder tree
    wire [8:0] stage1_sum [15:0];
    for (genvar i = 0; i < 16; i++) begin
        RecursiveAdder ra(
           .a(segment_count[i*2]),
           .b(segment_count[i*2+1]),
           .out(stage1_sum[i])
        );
    end

    wire [9:0] stage2_sum [7:0];
    for (genvar i = 0; i < 8; i++) begin
        RecursiveAdder ra(
           .a(stage1_sum[i*2][7:0]),
           .b(stage1_sum[i*2+1][7:0]),
           .out(stage2_sum[i])
        );
    end

    wire [10:0] stage3_sum [3:0];
    for (genvar i = 0; i < 4; i++) begin
        RecursiveAdder ra(
           .a(stage2_sum[i*2][8:1]),
           .b(stage2_sum[i*2+1][8:1]),
           .out(stage3_sum[i])
        );
    end

    wire [11:0] stage4_sum [1:0];
    for (genvar i = 0; i < 2; i++) begin
        RecursiveAdder ra(
           .a(stage3_sum[i*2][9:2]),
           .b(stage3_sum[i*2+1][9:2]),
           .out(stage4_sum[i])
        );
    end

    wire [12:0] final_sum;
    RecursiveAdder ra(
       .a(stage4_sum[0][10:3]),
       .b(stage4_sum[1][10:3]),
       .out(final_sum)
    );

    // Assign the output
    assign out = final_sum[7:0];

endmodule