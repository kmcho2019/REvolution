module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Initial 5-bit binary sum of A, B, and Cin
    wire [4:0] raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9
    // Condition: MSB set or bit3 set and (bit2 or bit1 set)
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Corrected sum: if correction needed add 6 (4'b0110) else 0
    wire [4:0] corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Output sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is MSB of corrected sum indicating decimal overflow beyond 9
    assign Cout = corrected_sum[4];

endmodule