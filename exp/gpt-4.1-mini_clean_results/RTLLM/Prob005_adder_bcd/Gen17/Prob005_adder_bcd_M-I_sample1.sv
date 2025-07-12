module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] sum_raw;
    wire       correction;

    // Raw addition of A, B, and Cin
    assign sum_raw = A + B + Cin;

    // Determine if correction needed (sum_raw > 9)
    // Using the same correction detection logic as standard BCD adders
    assign correction = sum_raw[4] | (sum_raw[3] & (sum_raw[2] | sum_raw[1]));

    // Add 6 correction in the same addition operation
    // Instead of adding 6 separately, add it along with A, B, and Cin if needed
    wire [4:0] correction_value = correction ? 5'd6 : 5'd0;

    wire [5:0] sum_corrected = {1'b0, A} + {1'b0, B} + {4'b0, Cin} + correction_value;

    // Output sum is lower 4 bits of corrected sum
    assign Sum = sum_corrected[3:0];

    // Carry out is the 5th bit of corrected sum
    assign Cout = sum_corrected[4];

endmodule