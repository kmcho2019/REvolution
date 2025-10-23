module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals
wire [3:0] sum_lower; // Sum of lower 4 bits
wire [3:0] sum_upper; // Sum of upper 4 bits
wire cout_lower; // Carry out of lower 4-bit adder
wire cout_upper; // Carry out of upper 4-bit adder
wire cin_upper; // Carry in for upper 4-bit adder

// Lower 4-bit ripple-carry adder
full_adder fa0(a[0], b[0], cin, sum_lower[0], cout_lower);
full_adder fa1(a[1], b[1], cout_lower, sum_lower[1], cout_lower);
full_adder fa2(a[2], b[2], cout_lower, sum_lower[2], cout_lower);
full_adder fa3(a[3], b[3], cout_lower, sum_lower[3], cout_lower);

// Upper 4-bit ripple-carry adder with carry lookahead
assign cin_upper = cout_lower;
full_adder fa4(a[4], b[4], cin_upper, sum_upper[0], cout_upper);
full_adder fa5(a[5], b[5], cout_upper, sum_upper[1], cout_upper);
full_adder fa6(a[6], b[6], cout_upper, sum_upper[2], cout_upper);
full_adder fa7(a[7], b[7], cout_upper, sum_upper[3], cout_upper);

// Concatenate sums
assign sum[3:0] = sum_lower;
assign sum[7:4] = sum_upper;

// Final carry out
assign cout = cout_upper;

endmodule

// Full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule