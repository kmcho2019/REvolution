module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [4:0] temp_sum;
    reg [3:0] corrected_sum;

    always @(A or B or Cin) begin
        // Perform binary addition of A, B, and Cin
        temp_sum = A + B + Cin;

        // Check if the sum exceeds 9 (binary 1001)
        if (temp_sum > 9) begin
            // Apply BCD correction by adding 6 to the sum
            corrected_sum = temp_sum + 6;
            // Generate a carry-out signal
            Cout = 1'b1;
        end else begin
            // No correction needed
            corrected_sum = temp_sum[3:0];
            // No carry-out signal
            Cout = 1'b0;
        end

        // Assign the corrected sum to the output
        Sum = corrected_sum;
    end

endmodule