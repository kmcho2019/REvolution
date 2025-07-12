module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);
    reg [4:0] raw_sum;
    reg [4:0] corrected_sum;
    reg       correction_needed;

    always @(*) begin
        // Step 1: Perform 4-bit binary addition with carry-in
        raw_sum = {1'b0, A} + {1'b0, B} + Cin;

        // Step 2: Determine if correction is needed (sum > 9)
        correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

        // Step 3: Add correction (6) if needed
        if (correction_needed)
            corrected_sum = raw_sum + 5'd6;
        else
            corrected_sum = raw_sum;

        // Step 4: Assign outputs
        Sum  = corrected_sum[3:0];
        Cout = corrected_sum[4];
    end

endmodule