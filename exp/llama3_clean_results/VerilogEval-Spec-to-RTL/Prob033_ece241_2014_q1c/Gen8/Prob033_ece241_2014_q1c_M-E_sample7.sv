module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Internal wires for the carry-save adder
    wire [4:0] sum_a;
    wire [4:0] carry_a;

    // Carry-save adder for the lower 4 bits
    full_adder fa0(a[0], b[0], 1'b0, sum_a[0], carry_a[0]);
    full_adder fa1(a[1], b[1], carry_a[0], sum_a[1], carry_a[1]);
    full_adder fa2(a[2], b[2], carry_a[1], sum_a[2], carry_a[2]);
    full_adder fa3(a[3], b[3], carry_a[2], sum_a[3], carry_a[3]);

    // Internal wires for the carry-save adder
    wire [4:0] sum_b;
    wire [4:0] carry_b;

    // Carry-save adder for the upper 4 bits
    full_adder fa4(a[4], b[4], 1'b0, sum_b[0], carry_b[0]);
    full_adder fa5(a[5], b[5], carry_b[0], sum_b[1], carry_b[1]);
    full_adder fa6(a[6], b[6], carry_b[1], sum_b[2], carry_b[2]);
    full_adder fa7(a[7], b[7], carry_b[2], sum_b[3], carry_b[3]);

    // Internal wires for the final adder
    wire [7:0] sum;
    wire      cout;

    // Final adder
    full_adder fa8(sum_a[0], sum_b[0], 1'b0, sum[0], cout);
    full_adder fa9(sum_a[1], sum_b[1], cout, sum[1], cout);
    full_adder fa10(sum_a[2], sum_b[2], cout, sum[2], cout);
    full_adder fa11(sum_a[3], sum_b[3], cout, sum[3], cout);
    full_adder fa12(carry_a[3], carry_b[3], cout, sum[4], cout);
    full_adder fa13(1'b0, 1'b0, cout, sum[5], cout);
    full_adder fa14(1'b0, 1'b0, cout, sum[6], cout);
    full_adder fa15(1'b0, 1'b0, cout, sum[7], cout);

    // Assign the result of the addition
    assign s = sum;

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