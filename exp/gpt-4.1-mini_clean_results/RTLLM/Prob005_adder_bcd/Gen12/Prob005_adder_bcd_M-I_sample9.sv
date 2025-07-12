module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;  // 5-bit raw sum including carry

    // Correction needed if raw_sum > 9:
    // raw_sum[4] = 1 means sum >= 16 (obviously > 9)
    // or if raw_sum[3] == 1 and (raw_sum[2] == 1 or raw_sum[1] == 1)
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Correction value to add (6) if needed; else zero
    wire [3:0] correction = correction_needed ? 4'b0110 : 4'b0000;

    // Add correction to lower 4 bits of raw_sum
    wire [4:0] corrected_sum = {1'b0, raw_sum[3:0]} + {1'b0, correction};

    // Final carry out is OR of raw carry out and carry out from correction addition
    assign Cout = raw_sum[4] | corrected_sum[4];

    // Corrected sum output (4 bits)
    assign Sum = corrected_sum[3:0];

endmodule