module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction;

    // Add A, B, and Cin (5-bit to capture carry out)
    assign raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9
    assign correction = (raw_sum > 5'd9);

    // Add correction if needed, output carry out and corrected sum
    assign {Cout, Sum} = raw_sum + (correction ? 5'd6 : 5'd0);

endmodule