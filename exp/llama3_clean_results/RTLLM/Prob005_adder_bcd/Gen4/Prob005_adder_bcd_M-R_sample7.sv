module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition
wire [4:0] sum_bin = A + B + Cin;

// Determine if correction is needed
wire correction_needed = (sum_bin > 9);

// Apply BCD correction if necessary
wire [4:0] sum_corrected = correction_needed ? (sum_bin + 6) : sum_bin;

// Assign Sum and Cout
assign Sum = sum_corrected[3:0];
assign Cout = correction_needed | sum_bin[4];

endmodule