module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] temp_sum;
    assign temp_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    always @(*) begin
        if (temp_sum > 9) begin
            // Apply BCD correction by adding 6
            Sum = temp_sum + 6;
            // Since we added 6, we need to check again if the sum exceeds 9
            if (Sum > 9) begin
                // If it does, generate a carry-out
                Cout = 1'b1;
                // The sum should be within the BCD range (0-9), so we take the lower 4 bits
                Sum = Sum[3:0];
            end else begin
                // No carry-out if the sum is within the BCD range
                Cout = 1'b0;
            end
        end else begin
            // If the initial sum does not exceed 9, no correction is needed
            Sum = temp_sum[3:0];
            // Check if the sum exceeds 9 without correction
            if (temp_sum > 9) begin
                Cout = 1'b1;
            end else begin
                Cout = 1'b0;
            end
        end
    end

endmodule