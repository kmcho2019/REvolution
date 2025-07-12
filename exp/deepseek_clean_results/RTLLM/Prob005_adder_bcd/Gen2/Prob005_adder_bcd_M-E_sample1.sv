module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [3:0] raw_sum;
wire raw_carry;
wire need_correction;

// Carry lookahead prediction for BCD correction
assign need_correction = (A > 9 - B - Cin) ||  // Sum will be >9
                        (A == 9 && B == 9 && Cin);  // Special case 9+9+1

// Binary addition with correction prediction
assign {raw_carry, raw_sum} = A + B + Cin;

// Apply correction if needed (parallel with addition)
assign Sum = need_correction ? raw_sum + 6 : raw_sum;

// Carry out is either from raw addition or correction
assign Cout = raw_carry | need_correction;

endmodule