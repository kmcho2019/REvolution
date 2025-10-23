module adder_bcd(
    input   [3:0] A,
    input   [3:0] B,
    input       Cin,
    output  [3:0] Sum,
    output      Cout
);

// Internal wires for the binary sum and carry
wire [3:0] bin_sum;
wire       bin_cout;

// Perform binary addition
assign bin_sum = A + B + Cin;
assign bin_cout = (A + B + Cin) > 9 ? 1'b1 : 1'b0;

// If the binary sum exceeds 9, apply correction
assign Cout = bin_cout;
assign Sum = (bin_sum > 9) ? bin_sum + 6 : bin_sum;

endmodule