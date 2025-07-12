module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       overflow;
    wire [4:0] sum_plus_6;

    // Step 1: Binary addition of A, B and Cin
    assign raw_sum = A + B + Cin;

    // Step 2: Overflow detection for BCD (if raw_sum > 9)
    // Overflow if bit4 is set or if bit3 is set with bit2 or bit1 set
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Compute raw_sum + 6 without full adder
    // Adding 6 (0110) to raw_sum can be done by bitwise addition:
    // sum_plus_6 = raw_sum + 6;
    // Here we do it with '+' operator since it is concise and synthesizable.
    assign sum_plus_6 = raw_sum + 5'd6;

    // Step 4: Select corrected sum based on overflow
    assign {Cout, Sum} = overflow ? sum_plus_6 : raw_sum;

endmodule