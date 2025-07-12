module adder_bcd(
    input  [3:0] A,  // First BCD input (4-bit)
    input  [3:0] B,  // Second BCD input (4-bit)
    input        Cin, // Carry-in input (1-bit)
    output [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output       Cout  // Carry-out output (1-bit)
);

    wire [4:0] binary_sum; // Intermediate sum before BCD correction
    reg  [3:0] Sum_reg;    // Registered output for Sum
    reg         Cout_reg;   // Registered output for Cout

    // Perform binary addition of A, B, and Cin
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // BCD correction and carry generation
    always @(A or B or Cin) begin
        if (binary_sum > 9) begin // If sum exceeds 9
            Sum_reg = binary_sum + 6; // Add 6 to correct the sum
            Cout_reg = 1'b1; // Generate carry-out
        end else begin
            Sum_reg = binary_sum[3:0]; // Assign sum directly if no correction needed
            Cout_reg = binary_sum[4]; // Assign carry-out based on the most significant bit of the sum
        end
    end

    assign Sum = Sum_reg;
    assign Cout = Cout_reg;

endmodule