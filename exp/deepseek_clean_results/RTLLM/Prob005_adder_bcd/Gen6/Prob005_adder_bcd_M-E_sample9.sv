module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [3:0] raw_sum;
wire [3:0] corrected_sum;
wire needs_correction;

// Compute both possible sums in parallel
assign raw_sum = A + B + Cin;
assign corrected_sum = raw_sum + 4'b0110; // +6 correction

// Determine if correction is needed (sum > 9)
assign needs_correction = (raw_sum > 9);

// Select appropriate sum and generate carry
assign Sum = needs_correction ? corrected_sum[3:0] : raw_sum;
assign Cout = needs_correction;

endmodule