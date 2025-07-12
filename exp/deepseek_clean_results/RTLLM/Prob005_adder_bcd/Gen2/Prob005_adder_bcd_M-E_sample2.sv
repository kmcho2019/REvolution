module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [3:0] sum_raw;
wire [3:0] sum_corrected;
wire correction_needed;

// Parallel computation paths
assign sum_raw = A + B + Cin;
assign sum_corrected = sum_raw + 4'd6;  // Pre-compute corrected sum

// Fast carry prediction (sum > 9 or carry generated)
assign correction_needed = (sum_raw > 9) | (A + B + Cin > 15);

// Output selection
assign Sum = correction_needed ? sum_corrected : sum_raw;
assign Cout = correction_needed;

endmodule