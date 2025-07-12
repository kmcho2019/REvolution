module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] sum_bin;       // 5-bit to hold binary sum and carry
    wire       correction_needed;
    wire [4:0] sum_corrected;

    // Step 1: Perform binary addition with carry-in
    assign sum_bin = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction is needed
    // Correction needed if raw sum > 9, which occurs if:
    // either carry-out is set (sum_bin[4] == 1)
    // or sum_bin[3:0] > 9 (1001)
    // sum_bin[3:0] > 9 can be checked as sum_bin[3] & (sum_bin[2] | sum_bin[1])
    assign correction_needed = sum_bin[4] | (sum_bin[3] & (sum_bin[2] | sum_bin[1]));

    // Step 3: Add correction (6) if needed
    assign sum_corrected = correction_needed ? sum_bin + 5'd6 : sum_bin;

    // Step 4: Assign outputs
    assign Sum  = sum_corrected[3:0];
    assign Cout = sum_corrected[4];

endmodule