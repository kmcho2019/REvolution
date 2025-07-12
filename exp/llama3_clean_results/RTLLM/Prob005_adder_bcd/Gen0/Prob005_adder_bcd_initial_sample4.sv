module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input         Cin,  // Carry-in input
    output  [3:0] Sum,  // 4-bit output representing the BCD sum
    output        Cout  // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply correction if necessary
    wire [3:0] sum_corrected;
    wire        carry_out;

    always @(*) begin
        if (binary_sum > 4'd9) begin
            // Apply correction by adding 6
            sum_corrected = binary_sum[3:0] + 4'd6;
            // Generate carry-out
            carry_out = 1'b1;
        end else begin
            // No correction needed, just assign the sum
            sum_corrected = binary_sum[3:0];
            // No carry-out
            carry_out = 1'b0;
        end
    end

    // Assign outputs
    assign Sum = sum_corrected;
    assign Cout = carry_out;

endmodule