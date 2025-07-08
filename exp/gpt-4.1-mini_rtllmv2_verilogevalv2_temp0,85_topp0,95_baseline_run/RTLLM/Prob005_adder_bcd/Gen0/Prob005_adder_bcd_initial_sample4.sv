module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum = A + B + Cin;       // 5-bit to capture carry out of 4-bit addition
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Correction needed if raw_sum > 9 or if carry out from addition is 1
    assign correction_needed = (raw_sum > 9);

    // If correction needed, add 6 (0110) to raw_sum
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule