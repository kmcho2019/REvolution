module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry = {cout, sum};
    assign carry[0] = cin;

    assign {carry[1], sum[0]} = a[0] + b[0] + carry[0];
    assign {carry[2], sum[1]} = a[1] + b[1] + carry[1];
    assign {carry[3], sum[2]} = a[2] + b[2] + carry[2];
    assign {carry[4], sum[3]} = a[3] + b[3] + carry[3];
    assign {carry[5], sum[4]} = a[4] + b[4] + carry[4];
    assign {carry[6], sum[5]} = a[5] + b[5] + carry[5];
    assign {carry[7], sum[6]} = a[6] + b[6] + carry[6];
    assign {carry[8], sum[7]} = a[7] + b[7] + carry[7];

endmodule