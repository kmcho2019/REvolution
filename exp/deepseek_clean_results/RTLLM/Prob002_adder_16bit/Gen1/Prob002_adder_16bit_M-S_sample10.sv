module adder_1bit (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [15:0] carry;

    adder_1bit fa0 (a[0], b[0], Cin,      y[0], carry[0]);
    adder_1bit fa1 (a[1], b[1], carry[0], y[1], carry[1]);
    adder_1bit fa2 (a[2], b[2], carry[1], y[2], carry[2]);
    adder_1bit fa3 (a[3], b[3], carry[2], y[3], carry[3]);
    adder_1bit fa4 (a[4], b[4], carry[3], y[4], carry[4]);
    adder_1bit fa5 (a[5], b[5], carry[4], y[5], carry[5]);
    adder_1bit fa6 (a[6], b[6], carry[5], y[6], carry[6]);
    adder_1bit fa7 (a[7], b[7], carry[6], y[7], carry[7]);
    adder_1bit fa8 (a[8], b[8], carry[7], y[8], carry[8]);
    adder_1bit fa9 (a[9], b[9], carry[8], y[9], carry[9]);
    adder_1bit fa10(a[10],b[10],carry[9], y[10],carry[10]);
    adder_1bit fa11(a[11],b[11],carry[10],y[11],carry[11]);
    adder_1bit fa12(a[12],b[12],carry[11],y[12],carry[12]);
    adder_1bit fa13(a[13],b[13],carry[12],y[13],carry[13]);
    adder_1bit fa14(a[14],b[14],carry[13],y[14],carry[14]);
    adder_1bit fa15(a[15],b[15],carry[14],y[15],Co);
endmodule