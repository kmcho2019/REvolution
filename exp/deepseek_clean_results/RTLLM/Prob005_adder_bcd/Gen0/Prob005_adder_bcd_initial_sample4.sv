module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [3:0] raw_sum;
wire raw_carry;
wire correction_needed;

// First perform binary addition
assign {raw_carry, raw_sum} = A + B + Cin;

// Determine if correction is needed (sum >9 or carry out)
assign correction_needed = (raw_sum > 4'd9) || (raw_carry == 1'b1);

// Apply correction if needed
assign {Cout, Sum} = correction_needed ? {1'b1, raw_sum + 4'd6} : {raw_carry, raw_sum};

endmodule