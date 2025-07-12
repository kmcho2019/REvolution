module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // 5-bit binary addition of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9
    // Implement comparator with combinational logic:
    // raw_sum > 9 if MSB (bit 4) is set or 
    // if bit3 is set and at least one of bit2 or bit1 is set
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 (0110) if correction needed, else add 0
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Output sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry-out indicates that the sum exceeds one BCD digit
    assign Cout = correction_needed;

endmodule