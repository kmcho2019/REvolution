module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit)
    wire [4:0] sum_ext = A + B + Cin;
    
    // Simplified overflow detection (sum > 9)
    wire overflow = (sum_ext > 9);

    // Apply correction: if overflow, add 6 (0110)
    wire [3:0] corrected_sum = sum_ext[3:0] + 4'b0110;
    
    // Select between raw sum and corrected sum
    assign Sum = overflow ? corrected_sum : sum_ext[3:0];
    assign Cout = overflow;

endmodule