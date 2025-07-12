// Module to count the number of ones in a single bit
module BitCounter(
    input in,
    output [7:0] out
);
    assign out = in ? 8'b1 : 8'b0;
endmodule

// Module to calculate the sum of two counts
module CountSum(
    input [7:0] a,
    input [7:0] b,
    output [8:0] out
);
    assign out = a + b;
endmodule

// Top-level module for population count
module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Initialize arrays to store the bit counters and count sums
    wire [7:0] bit_count [254:0];
    wire [8:0] count_sum [127:0];
    wire [9:0] count_sum_2 [63:0];
    wire [10:0] count_sum_3 [31:0];
    wire [11:0] count_sum_4 [15:0];
    wire [12:0] count_sum_5 [7:0];
    wire [13:0] count_sum_6 [3:0];
    wire [14:0] count_sum_7 [1:0];

    // Instantiate BitCounter for each bit
    genvar i;
    for (i = 0; i < 255; i++) begin
        BitCounter bc(
          .in(in[i]),
          .out(bit_count[i])
        );
    end

    // First level of count sums
    for (i = 0; i < 127; i++) begin
        CountSum cs(
          .a(bit_count[i*2]),
          .b(bit_count[i*2+1]),
          .out(count_sum[i])
        );
    end

    // Second level of count sums
    for (i = 0; i < 63; i++) begin
        CountSum cs2(
          .a(count_sum[i*2][7:0]),
          .b(count_sum[i*2+1][7:0]),
          .out(count_sum_2[i])
        );
    end

    // Third level of count sums
    for (i = 0; i < 31; i++) begin
        CountSum cs3(
          .a(count_sum_2[i*2][8:0]),
          .b(count_sum_2[i*2+1][8:0]),
          .out(count_sum_3[i])
        );
    end

    // Fourth level of count sums
    for (i = 0; i < 15; i++) begin
        CountSum cs4(
          .a(count_sum_3[i*2][9:0]),
          .b(count_sum_3[i*2+1][9:0]),
          .out(count_sum_4[i])
        );
    end

    // Fifth level of count sums
    for (i = 0; i < 7; i++) begin
        CountSum cs5(
          .a(count_sum_4[i*2][10:0]),
          .b(count_sum_4[i*2+1][10:0]),
          .out(count_sum_5[i])
        );
    end

    // Sixth level of count sums
    for (i = 0; i < 3; i++) begin
        CountSum cs6(
          .a(count_sum_5[i*2][11:0]),
          .b(count_sum_5[i*2+1][11:0]),
          .out(count_sum_6[i])
        );
    end

    // Seventh level of count sums
    for (i = 0; i < 1; i++) begin
        CountSum cs7(
          .a(count_sum_6[i*2][12:0]),
          .b(count_sum_6[i*2+1][12:0]),
          .out(count_sum_7[i])
        );
    end

    // Final count sum
    assign out = count_sum_7[0][7:0];

endmodule