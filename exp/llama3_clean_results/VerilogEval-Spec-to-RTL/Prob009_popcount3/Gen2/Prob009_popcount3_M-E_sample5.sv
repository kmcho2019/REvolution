module TopModule(
    input  [2:0] in,
    output [1:0] out
);

wire [1:0] half_adder_out1;
wire [1:0] half_adder_out2;

// Half-adder 1: Count '1's in in[0] and in[1]
half_adder ha1(.a(in[0]), .b(in[1]), .sum(half_adder_out1[0]), .carry(half_adder_out1[1]));

// Half-adder 2: Count '1's in half_adder_out1[0] (sum of in[0] and in[1]) and in[2]
half_adder ha2(.a(half_adder_out1[0]), .b(in[2]), .sum(half_adder_out2[0]), .carry(half_adder_out2[1]));

// Full-adder: Sum up the counts from the half-adders
full_adder fa1(.a(half_adder_out1[1]), .b(half_adder_out2[1]), .cin(1'b0), .sum(out[1]), .cout(out[0]));

endmodule

module half_adder(
    input  a,
    input  b,
    output sum,
    output carry
);

assign sum = a ^ b;
assign carry = a & b;

endmodule

module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule