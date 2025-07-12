module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [3:0] raw_sum;
wire carry_out;
wire needs_correction;

// Calculate raw sum and carry
assign {carry_out, raw_sum} = A + B + Cin;

// Overflow detection (sum > 9) using simpler logic:
// Either we have carry_out, or sum[3] is set and (sum[2] or sum[1])
assign needs_correction = carry_out | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

// Apply correction only when needed
assign Sum = needs_correction ? (raw_sum + 6) : raw_sum;
assign Cout = needs_correction;

endmodule