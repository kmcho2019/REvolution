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

    // Step 1: 5-bit addition of A, B and Cin
    assign raw_sum = A + B + Cin;

    // Step 2: Correction condition without full comparator:
    // Correction needed if:
    // - raw_sum > 9:
    //   raw_sum[4] == 1 (sum >= 16)
    // OR
    //   raw_sum[3] & (raw_sum[2] | raw_sum[1]) (sum between 10 and 15)
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add correction (6) if needed
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Step 4: Output sum and carry
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule