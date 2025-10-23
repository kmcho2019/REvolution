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

    // Correction needed if sum > 9: sum[4] = 1 or (sum[3] = 1 and (sum[2] = 1 or sum[1] = 1))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 (binary 0110) if correction needed
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule