module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;         // sum of A, B, and Cin before BCD correction
    wire       correction;      // indicates if correction needed (sum > 9)
    wire [4:0] corrected_sum;   // sum after adding correction (6) if needed

    // Step 1: Calculate raw sum (5-bit to hold carry out)
    assign raw_sum = A + B + Cin;

    // Step 2: Determine if correction is required (sum > 9)
    // Correction condition: raw_sum > 9
    assign correction = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add BCD correction (6) if required
    assign corrected_sum = raw_sum + (correction ? 5'd6 : 5'd0);

    // Step 4: Assign outputs
    assign Sum  = corrected_sum[3:0];    // lower 4 bits after correction
    assign Cout = correction;             // carry-out is correction signal

endmodule