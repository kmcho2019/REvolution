module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;      // 5-bit to hold sum + carry
    wire [4:0] corrected_sum;
    wire       add_correction;

    // Perform binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Condition for BCD correction:
    // If raw_sum > 9 or if bit4 is set (carry from 4-bit addition)
    assign add_correction = (raw_sum > 5'd9);

    // Add correction of 6 if needed
    assign corrected_sum = add_correction ? (raw_sum + 5'd6) : raw_sum;

    // Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule