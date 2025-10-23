module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       overflow;

    // Perform binary addition of inputs and carry-in
    assign raw_sum = A + B + Cin;

    // Detect overflow if sum > 9 (BCD invalid)
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Assign corrected sum and carry-out directly using conditional addition
    assign {Cout, Sum} = overflow ? (raw_sum + 5'd6) : raw_sum;

endmodule