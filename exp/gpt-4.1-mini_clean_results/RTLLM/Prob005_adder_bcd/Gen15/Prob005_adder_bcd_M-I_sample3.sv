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
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Optimized comparator to check if raw_sum > 9
    // Condition: raw_sum[4] == 1 OR (raw_sum[3] == 1 AND (raw_sum[2] OR raw_sum[1]) == 1)
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Correction value 6 = 4'b0110
    // Add correction only if needed
    // Use a 5-bit adder: raw_sum + (correction_needed ? 5'b00110 : 5'b00000)
    assign corrected_sum = raw_sum + (correction_needed ? 5'b00110 : 5'b00000);

    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule