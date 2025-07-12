module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_bin = A + B + Cin;

    // Check if the sum exceeds 9 and generate correction and carry-out
    assign Cout = (sum_bin > 9)? 1'b1 : 1'b0;
    assign Sum = (sum_bin > 9)? sum_bin + 6 : sum_bin;

    // To prevent Sum from being more than 4 bits when adding 6, 
    // we use the modulo operator to ensure it wraps around
    // However, the correct approach to keep the sum within 4 bits is to 
    // simply use the lower 4 bits after adding the correction, which is implicit in the above assignment.

endmodule