module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    wire [15:0] pp0 = B[0] ? ({8'd0, A} << 0) : 16'd0;
    wire [15:0] pp1 = B[1] ? ({8'd0, A} << 1) : 16'd0;
    wire [15:0] pp2 = B[2] ? ({8'd0, A} << 2) : 16'd0;
    wire [15:0] pp3 = B[3] ? ({8'd0, A} << 3) : 16'd0;
    wire [15:0] pp4 = B[4] ? ({8'd0, A} << 4) : 16'd0;
    wire [15:0] pp5 = B[5] ? ({8'd0, A} << 5) : 16'd0;
    wire [15:0] pp6 = B[6] ? ({8'd0, A} << 6) : 16'd0;
    wire [15:0] pp7 = B[7] ? ({8'd0, A} << 7) : 16'd0;

    assign product = pp0 + pp1 + pp2 + pp3 + pp4 + pp5 + pp6 + pp7;

endmodule