module TopModule(
    input  [2:0] in,
    output [1:0] out
);

wire sum_0, carry_0, sum_1, carry_1;

// Half adder to count '1's in in[0] and in[1]
assign sum_0 = in[0] ^ in[1];
assign carry_0 = in[0] & in[1];

// Half adder to count '1's in sum_0, carry_0 and in[2]
assign sum_1 = sum_0 ^ in[2] ^ carry_0;
assign carry_1 = (sum_0 & in[2]) | (sum_0 & carry_0) | (in[2] & carry_0);

assign out[0] = sum_1;
assign out[1] = carry_1;

endmodule