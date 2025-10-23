module adder_bcd (
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin, // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum
    output Cout // Carry-out output
);

    // Temporary variable to hold the sum of A, B, and Cin
    wire [4:0] temp_sum;

    // Perform binary addition of A, B, and Cin
    assign temp_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if the sum exceeds 9 and apply BCD correction if needed
    reg [3:0] corrected_sum;
    reg Cout_reg;

    always @(*) begin
        // If the sum exceeds 9, apply the BCD correction
        if (temp_sum > 9) begin
            // Apply the correction by adding 6 to the sum
            corrected_sum = temp_sum[3:0] + 4'd6;
            // Generate a carry-out
            Cout_reg = 1'b1;
        end else begin
            // If the sum does not exceed 9, no correction is needed
            corrected_sum = temp_sum[3:0];
            // No carry-out is generated
            Cout_reg = temp_sum[4];
        end
    end

    // Assign the final sum and carry-out to the output ports
    assign Sum = corrected_sum;
    assign Cout = Cout_reg;

endmodule