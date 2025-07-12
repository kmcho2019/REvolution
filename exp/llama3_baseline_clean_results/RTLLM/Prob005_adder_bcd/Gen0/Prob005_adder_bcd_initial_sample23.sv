module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin, // Carry-in input
    output [3:0] Sum, // 4-bit output representing the BCD sum
    output       Cout  // Carry-out output
);

    wire [4:0] temp_sum; // Temporary sum to hold the binary addition result

    // Perform binary addition of A, B, and Cin
    assign temp_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    assign Sum = (temp_sum > 9) ? (temp_sum + 6) : temp_sum;
    
    // Generate carry-out if the result after correction exceeds 9
    assign Cout = (temp_sum > 9) ? 1'b1 : ((temp_sum + 6) > 9) ? 1'b1 : 1'b0;

    // Ensure Sum is within 4-bit range
    assign Sum = Sum[3:0];

endmodule