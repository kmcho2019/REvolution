module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [3:0] raw_sum;
wire raw_carry;
wire needs_correction;

// Parallel computation of raw sum and correction prediction
assign {raw_carry, raw_sum} = A + B + Cin;

// Correction prediction logic (will sum be >9?)
assign needs_correction = raw_carry || 
                         (raw_sum[3] && (raw_sum[2] || raw_sum[1]));

// Compute both possible sums in parallel
wire [3:0] corrected_sum = raw_sum + 4'b0110; // +6 correction
wire corrected_carry = raw_carry || corrected_sum[4];

// Select appropriate result based on prediction
assign Sum = needs_correction ? corrected_sum[3:0] : raw_sum;
assign Cout = needs_correction ? 1'b1 : raw_carry;

endmodule