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
    // True when sum > 9 (1001) or carry generated (sum[4])
    wire correction_needed = initial_sum[4] | 
                           (initial_sum[3] & (initial_sum[2] | initial_sum[1]));
    
    // Apply correction efficiently:
    // When needed: sum = initial_sum + 6 (0110)
    // When not: sum = initial_sum + 0 (0000)
    assign Sum = initial_sum[3:0] ^ {4{correction_needed}} & 4'b0110;
    
    // Carry out is same as correction needed signal
    assign Cout = correction_needed;

endmodule