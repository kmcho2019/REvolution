module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Perform binary addition with carry-in
    wire [4:0] raw_sum = A + B + Cin;

    // Determine if correction is needed: raw_sum >= 10 (decimal)
    // 10 decimal = 5'b01010
    wire correction_needed = (raw_sum >= 5'd10);

    // If correction needed, add 6 (5'b00110) to raw_sum
    wire [4:0] corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Sum is lower 4 bits of corrected_sum
    assign Sum  = corrected_sum[3:0];

    // Carry out if correction was needed (sum > 9)
    assign Cout = correction_needed;

endmodule