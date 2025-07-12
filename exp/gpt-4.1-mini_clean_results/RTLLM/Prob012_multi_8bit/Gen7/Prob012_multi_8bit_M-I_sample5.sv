module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);

    wire [15:0] A_ext = {8'b0, A};  // Pre-extend multiplicand once

    // Generate partial products by ANDing A with each bit of B and shifting
    wire [15:0] pp[7:0];
    assign pp[0] = B[0] ? (A_ext << 0) : 16'b0;
    assign pp[1] = B[1] ? (A_ext << 1) : 16'b0;
    assign pp[2] = B[2] ? (A_ext << 2) : 16'b0;
    assign pp[3] = B[3] ? (A_ext << 3) : 16'b0;
    assign pp[4] = B[4] ? (A_ext << 4) : 16'b0;
    assign pp[5] = B[5] ? (A_ext << 5) : 16'b0;
    assign pp[6] = B[6] ? (A_ext << 6) : 16'b0;
    assign pp[7] = B[7] ? (A_ext << 7) : 16'b0;

    // Balanced adder tree to sum partial products
    wire [15:0] sum_level1[3:0];
    assign sum_level1[0] = pp[0] + pp[1];
    assign sum_level1[1] = pp[2] + pp[3];
    assign sum_level1[2] = pp[4] + pp[5];
    assign sum_level1[3] = pp[6] + pp[7];

    wire [15:0] sum_level2[1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    wire [15:0] sum_level3;
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    assign product = sum_level3;

endmodule