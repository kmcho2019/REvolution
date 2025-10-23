module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output Cout      // Carry-out output
);

    // Internal signal to hold the binary sum of A, B, and Cin
    reg [4:0] binary_sum;

    // Perform binary addition of A, B, and Cin
    always @(A or B or Cin) begin
        binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};
        
        // If the binary sum exceeds 9 (binary 1001), apply BCD correction
        if (binary_sum > 9) begin
            // Apply correction of 6 (binary 0110) to the sum
            Sum = binary_sum[3:0] + 4'd6;
            // Generate carry-out
            Cout = 1'b1;
        end else begin
            // If no correction needed, the sum is directly the binary sum
            Sum = binary_sum[3:0];
            // No carry-out needed
            Cout = 1'b0;
        end
    end

endmodule