module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    // Declare partial products - each 16 bits wide (A extended and shifted)
    wire [15:0] pp0 = B[0] ? {8'b0, A}           << 0 : 16'b0;
    wire [15:0] pp1 = B[1] ? {8'b0, A}           << 1 : 16'b0;
    wire [15:0] pp2 = B[2] ? {8'b0, A}           << 2 : 16'b0;
    wire [15:0] pp3 = B[3] ? {8'b0, A}           << 3 : 16'b0;
    wire [15:0] pp4 = B[4] ? {8'b0, A}           << 4 : 16'b0;
    wire [15:0] pp5 = B[5] ? {8'b0, A}           << 5 : 16'b0;
    wire [15:0] pp6 = B[6] ? {8'b0, A}           << 6 : 16'b0;
    wire [15:0] pp7 = B[7] ? {8'b0, A}           << 7 : 16'b0;

    // Sum all partial products sequentially
    wire [15:0] sum1 = pp0 + pp1;
    wire [15:0] sum2 = sum1 + pp2;
    wire [15:0] sum3 = sum2 + pp3;
    wire [15:0] sum4 = sum3 + pp4;
    wire [15:0] sum5 = sum4 + pp5;
    wire [15:0] sum6 = sum5 + pp6;
    wire [15:0] sum7 = sum6 + pp7;

    assign product = sum7;

endmodule