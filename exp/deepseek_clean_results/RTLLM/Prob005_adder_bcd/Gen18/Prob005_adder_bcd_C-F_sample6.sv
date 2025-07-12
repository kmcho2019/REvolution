module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit result)
    wire [4:0] initial_sum = A + B + Cin;
    
    // Optimized correction detection:
    // True when either:
    // 1. Carry out occurs (sum > 15)
    // 2. Sum is 10-15 (4'b1010-4'b1111)
    // 3. Sum is 9 with carry (handled by initial_sum[4])
    wire correction_needed = initial_sum[4] |  // Case 1 & 3
                           (&initial_sum[3:2]) |  // 11xx cases
                           (initial_sum[3] & (initial_sum[2] | initial_sum[1]));  // 101x, 1001
    
    // Apply correction using efficient bit manipulation:
    // correction_needed ? +6 (0110) : +0 (0000)
    assign Sum = initial_sum[3:0] + {1'b0, correction_needed, correction_needed, 1'b0};
    assign Cout = correction_needed;

endmodule