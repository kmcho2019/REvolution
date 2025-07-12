module TopModule(
    input  [3:0] x,   // 4-bit input x
    input  [3:0] y,   // 4-bit input y
    output [4:0] sum  // 5-bit output sum including overflow
);

// Internal signals for carries
wire c1, c2, c3, c4;

// Full adder for least significant bits
full_adder fa0(x[0], y[0], 1'b0, sum[0], c1);

// Full adder for next bits with carry from previous
full_adder fa1(x[1], y[1], c1, sum[1], c2);

// Full adder for next bits with carry from previous
full_adder fa2(x[2], y[2], c2, sum[2], c3);

// Full adder for most significant bits with carry from previous
full_adder fa3(x[3], y[3], c3, sum[3], c4);

// Assign the final carry as the overflow bit
assign sum[4] = c4;

endmodule

// Full adder module definition
module full_adder(
    input  a,    // First operand
    input  b,    // Second operand
    input  cin,  // Carry in
    output sum,  // Sum
    output cout  // Carry out
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule