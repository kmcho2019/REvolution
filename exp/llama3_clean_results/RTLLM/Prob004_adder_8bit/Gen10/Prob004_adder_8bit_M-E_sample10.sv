module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Layer 1: Full adders for bits 0-3
wire [1:0] sum0;
wire [1:0] carry0;
full_adder fa0(a[0], b[0], cin, sum0[0], carry0[0]);
full_adder fa1(a[1], b[1], carry0[0], sum0[1], carry0[1]);

// Layer 2: Full adders for bits 4-7
wire [1:0] sum1;
wire [1:0] carry1;
full_adder fa2(a[2], b[2], carry0[1], sum1[0], carry1[0]);
full_adder fa3(a[3], b[3], carry1[0], sum1[1], carry1[1]);

// Layer 3: Full adders for bits 4-7
wire [1:0] sum2;
wire [1:0] carry2;
full_adder fa4(a[4], b[4], carry1[1], sum2[0], carry2[0]);
full_adder fa5(a[5], b[5], carry2[0], sum2[1], carry2[1]);

// Layer 4: Full adder for bits 6-7
wire [1:0] sum3;
wire [1:0] carry3;
full_adder fa6(a[6], b[6], carry2[1], sum3[0], carry3[0]);
full_adder fa7(a[7], b[7], carry3[0], sum3[1], carry3[1]);

// Output logic
assign sum[0] = sum0[0];
assign sum[1] = sum0[1];
assign sum[2] = sum1[0];
assign sum[3] = sum1[1];
assign sum[4] = sum2[0];
assign sum[5] = sum2[1];
assign sum[6] = sum3[0];
assign sum[7] = sum3[1];
assign cout = carry3[1];

endmodule

module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);
endmodule