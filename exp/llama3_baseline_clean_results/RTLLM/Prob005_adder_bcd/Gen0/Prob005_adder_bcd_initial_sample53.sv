module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

    // Temporary variable to hold the binary sum of A, B, and Cin
    reg [4:0] temp_sum;

    // Perform binary addition of A, B, and Cin
    always @(*) begin
        temp_sum = {A[3:0]} + {B[3:0]} + Cin;

        // If the sum exceeds 9 (1001 in binary), apply BCD correction
        if (temp_sum > 9) begin
            // Apply correction by adding 6 to the sum
            Sum = temp_sum + 6;
            // Generate carry-out signal
            Cout = 1'b1;
        end else begin
            // No correction needed, Sum is the binary sum
            Sum = temp_sum[3:0];
            // No carry-out
            Cout = 1'b0;
        end
    end

endmodule