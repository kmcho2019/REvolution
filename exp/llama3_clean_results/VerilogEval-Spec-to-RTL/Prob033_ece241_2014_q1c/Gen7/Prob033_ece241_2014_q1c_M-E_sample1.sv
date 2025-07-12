module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Internal wires for the Wallace tree adder
    wire [7:0] sum;
    wire [8:0] carry;

    // Wallace tree adder
    wire [3:0] p0, p1, p2, p3;
    wire [1:0] c0, c1;

    // First level of addition
    full_adder fa0(a[0], b[0], 1'b0, p0[0], c0[0]);
    full_adder fa1(a[1], b[1], 1'b0, p0[1], c0[1]);
    full_adder fa2(a[2], b[2], 1'b0, p1[0], c1[0]);
    full_adder fa3(a[3], b[3], 1'b0, p1[1], c1[1]);
    full_adder fa4(a[4], b[4], 1'b0, p2[0], c0[0]);
    full_adder fa5(a[5], b[5], 1'b0, p2[1], c0[1]);
    full_adder fa6(a[6], b[6], 1'b0, p3[0], c1[0]);
    full_adder fa7(a[7], b[7], 1'b0, p3[1], c1[1]);

    // Second level of addition
    full_adder fa8(p0[0], p1[0], c0[0], p0[0], c0[0]);
    full_adder fa9(p0[1], p1[1], c0[1], p0[1], c0[1]);
    full_adder fa10(p2[0], p3[0], c1[0], p2[0], c1[0]);
    full_adder fa11(p2[1], p3[1], c1[1], p2[1], c1[1]);

    // Third level of addition
    full_adder fa12(p0[0], p2[0], c0[0], sum[0], carry[1]);
    full_adder fa13(p0[1], p2[1], c0[1], sum[1], carry[2]);
    full_adder fa14(p1[0], p3[0], c1[0], sum[2], carry[3]);
    full_adder fa15(p1[1], p3[1], c1[1], sum[3], carry[4]);

    // Final level of addition
    full_adder fa16(sum[0], 1'b0, carry[1], sum[0], carry[2]);
    full_adder fa17(sum[1], 1'b0, carry[2], sum[1], carry[3]);
    full_adder fa18(sum[2], 1'b0, carry[3], sum[2], carry[4]);
    full_adder fa19(sum[3], 1'b0, carry[4], sum[3], carry[5]);

    // Assign the result of the addition
    assign s[0] = sum[0];
    assign s[1] = sum[1];
    assign s[2] = sum[2];
    assign s[3] = sum[3];
    assign s[4] = carry[4];
    assign s[5] = carry[5];
    assign s[6] = carry[6];
    assign s[7] = carry[7];

    // Detect signed overflow
    assign overflow = (a[7] == b[7] && a[7]!= s[7]);

endmodule

// Full adder module
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);

    // Calculate the sum and carry-out
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule