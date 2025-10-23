module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Intermediate wires to hold the binary sum and the carry
    wire [4:0] binary_sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if the sum exceeds 9 (BCD correction needed)
    always @(A or B or Cin) begin
        if (binary_sum > 9) begin
            // Apply BCD correction and generate carry-out
            Sum = binary_sum[3:0] + 4'b0110;  // Add 6 for BCD correction
            Cout = 1'b1;  // Set carry-out
        end else begin
            // No correction needed, just assign the sum
            Sum = binary_sum[3:0];
            Cout = binary_sum[4];  // Carry-out is the MSB of the binary sum
        end
    end

endmodule