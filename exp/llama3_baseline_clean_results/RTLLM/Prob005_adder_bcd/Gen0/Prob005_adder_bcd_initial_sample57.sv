module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output for the sum
    output Cout      // Carry-out output
);

    // Internal wire to hold the binary sum before BCD correction
    wire [4:0] binary_sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = {1'b0, A} + {1'b0, B} + {3'b000, Cin};

    // Determine if the sum exceeds 9 and apply BCD correction
    assign Sum = (binary_sum > 9) ? binary_sum + 6 : binary_sum;
    
    // Since Sum is only 4 bits, any value greater than 9 after correction will wrap around,
    // but this is handled by the Cout logic which checks the original binary_sum.

    // Generate carry-out (Cout) if the sum exceeds 9
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

endmodule