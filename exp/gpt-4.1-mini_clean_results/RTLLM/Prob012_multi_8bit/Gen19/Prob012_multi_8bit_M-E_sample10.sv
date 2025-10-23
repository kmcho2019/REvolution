module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Stage 0: initial sum is zero
    wire [15:0] sum_0 = 16'd0;

    // Generate a chain of partial sums: at each stage i, add shifted A if B[i] is 1
    wire [15:0] sum_1;
    assign sum_1 = B[0] ? ( {8'd0, A} << 0 ) + sum_0 : sum_0;

    wire [15:0] sum_2;
    assign sum_2 = B[1] ? ( {8'd0, A} << 1 ) + sum_1 : sum_1;

    wire [15:0] sum_3;
    assign sum_3 = B[2] ? ( {8'd0, A} << 2 ) + sum_2 : sum_2;

    wire [15:0] sum_4;
    assign sum_4 = B[3] ? ( {8'd0, A} << 3 ) + sum_3 : sum_3;

    wire [15:0] sum_5;
    assign sum_5 = B[4] ? ( {8'd0, A} << 4 ) + sum_4 : sum_4;

    wire [15:0] sum_6;
    assign sum_6 = B[5] ? ( {8'd0, A} << 5 ) + sum_5 : sum_5;

    wire [15:0] sum_7;
    assign sum_7 = B[6] ? ( {8'd0, A} << 6 ) + sum_6 : sum_6;

    wire [15:0] sum_8;
    assign sum_8 = B[7] ? ( {8'd0, A} << 7 ) + sum_7 : sum_7;

    // Final product
    assign product = sum_8;

endmodule