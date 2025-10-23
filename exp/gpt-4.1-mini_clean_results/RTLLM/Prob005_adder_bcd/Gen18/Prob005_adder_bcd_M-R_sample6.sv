module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);
    reg [4:0] raw_sum;
    reg       correction_needed;
    reg [4:0] corrected_sum;

    always @(*) begin
        // Step 1: Add inputs and carry-in
        raw_sum = A + B + Cin;

        // Step 2: Detect if correction is needed:
        // Correction needed if raw_sum > 9, equivalent to:
        // raw_sum[4] == 1 (sum >= 16) OR (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
        // Because BCD invalid if sum >= 10 (binary 01010)
        correction_needed = (raw_sum[4]) || (raw_sum[3] && (raw_sum[2] || raw_sum[1]));

        // Step 3: Add 6 if correction is needed
        if (correction_needed)
            corrected_sum = raw_sum + 5'd6;
        else
            corrected_sum = raw_sum;

        // Step 4: Assign output sum and carry
        Sum  = corrected_sum[3:0];
        Cout = correction_needed;
    end
endmodule