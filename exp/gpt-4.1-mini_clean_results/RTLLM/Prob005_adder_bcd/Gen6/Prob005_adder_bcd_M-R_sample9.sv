module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;           // Sum of A, B, and Cin (5 bits)
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Step 1: Binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if correction is needed (sum > 9)
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: If correction needed, add 6 (4'b0110) to lower 4 bits of raw_sum
    // corrected_sum = raw_sum + 6
    assign corrected_sum = raw_sum + 5'd6;

    // Step 4: Select final Sum and Cout based on correction
    assign Sum  = correction_needed ? corrected_sum[3:0] : raw_sum[3:0];
    assign Cout = correction_needed ? corrected_sum[4] : raw_sum[4];

endmodule