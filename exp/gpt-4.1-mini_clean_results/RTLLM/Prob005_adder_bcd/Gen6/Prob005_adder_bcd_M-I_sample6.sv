module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Step 1: Perform 4-bit binary addition with carry-in, result is 5 bits
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction needed by simplified Boolean logic
    // Correction needed if raw_sum > 9
    // raw_sum > 9 condition can be written as:
    // correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Correction value is 6 (4'b0110), zero-extended to 5 bits for addition
    // Add correction only if needed
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Step 4: Assign outputs
    assign Sum  = corrected_sum[3:0];  // 4-bit corrected BCD sum
    assign Cout = corrected_sum[4];    // Carry-out indicating BCD overflow

endmodule