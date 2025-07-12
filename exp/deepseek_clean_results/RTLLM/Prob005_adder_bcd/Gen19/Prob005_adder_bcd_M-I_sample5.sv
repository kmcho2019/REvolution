module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit)
    wire [4:0] sum_ext = A + B + Cin;
    
    // Optimized overflow detection:
    // sum > 9 when either:
    // 1. Carry-out occurs (sum_ext[4] = 1), or
    // 2. Sum[3:0] >= 10 (detected more efficiently)
    wire overflow = sum_ext[4] | 
                   (sum_ext[3] & sum_ext[1]) |  // 101x (10 or 11)
                   (sum_ext[3] & sum_ext[2]);   // 11xx (12-15)

    // Compute corrected sum (sum + 6) when overflow occurs
    wire [3:0] corrected_sum = sum_ext[3:0] + 4'b0110;
    
    // Select between original sum and corrected sum
    assign Sum = overflow ? corrected_sum : sum_ext[3:0];
    assign Cout = overflow;

endmodule