module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout     // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Determine if the sum exceeds 9 (binary 1001) and apply correction
    reg [3:0] corrected_sum;
    always @(*) begin
        if (binary_sum[4] == 1 || binary_sum[3:0] > 4'd9) begin
            // Apply correction by adding 6 to the sum
            corrected_sum = binary_sum[3:0] + 4'd6;
        end else begin
            corrected_sum = binary_sum[3:0];
        end
    end

    // Assign the corrected sum to the output Sum
    assign Sum = corrected_sum;

    // Generate carry-out (Cout) if the result exceeds 9
    assign Cout = (binary_sum[4] == 1) || (binary_sum[3:0] > 4'd9);

endmodule