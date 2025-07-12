module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: Calculate raw 5-bit sum of A, B, and Cin
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Detect if correction is needed when raw_sum > 9
    // Correction needed if bit4 set or bit3 set and (bit2 or bit1 set)
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditionally add 6 (0110) to raw_sum for BCD correction
    wire [4:0] corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Step 4: Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule