module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out
    wire [4:0] sum_ext = A + B + Cin;
    
    // Optimized overflow detection:
    // sum > 9 when either:
    // 1. Carry-out occurs (sum_ext[4] = 1), or
    // 2. Sum[3:0] >= 10 (detected more efficiently)
    wire overflow = sum_ext[4] | 
                   (sum_ext[3] & sum_ext[1]) |  // 8+2
                   (sum_ext[3] & sum_ext[2]);   // 8+4 or 8+4+2

    // Simplified correction using arithmetic
    wire [3:0] corrected_sum = sum_ext[3:0] + (overflow ? 4'b0110 : 4'b0000);
    
    assign Sum = corrected_sum;
    assign Cout = overflow;

endmodule