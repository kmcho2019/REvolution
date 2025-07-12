module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Half adder module
module half_adder(
    input   a,
    input   b,
    output  sum,
    output  cout
);
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

// Instantiating half adders for each bit position
wire [7:0] carry;
half_adder ha0(a[0], b[0], sum[0], carry[0]);
half_adder ha1(a[1], b[1], sum[1], carry[1]);
half_adder ha2(a[2], b[2], sum[2], carry[2]);
half_adder ha3(a[3], b[3], sum[3], carry[3]);
half_adder ha4(a[4], b[4], sum[4], carry[4]);
half_adder ha5(a[5], b[5], sum[5], carry[5]);
half_adder ha6(a[6], b[6], sum[6], carry[6]);
half_adder ha7(a[7], b[7], sum[7], carry[7]);

// Carry-in for each bit position
assign carry[0] = cin;
assign carry[1] = carry[0];
assign carry[2] = carry[1];
assign carry[3] = carry[2];
assign carry[4] = carry[3];
assign carry[5] = carry[4];
assign carry[6] = carry[5];
assign carry[7] = carry[6];

// Carry-out
assign cout = carry[7];

endmodule