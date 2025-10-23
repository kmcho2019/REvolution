module TopModule(
    input  [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output
);

// Half adder to count '1's in two bits
wire [1:0] half_adder_sum;
assign half_adder_sum = in[1:0] + 1'b0;

// Full adder to count '1's in three bits
assign out = half_adder_sum + in[2];

endmodule