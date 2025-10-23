module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit result)
    wire [4:0] initial_sum = A + B + Cin;
    
    // More efficient correction detection using bit pattern matching
    // Detects when sum is 10-19 (binary 1010-10011)
    wire correction_needed = initial_sum[4] | 
                           (initial_sum[3] & (initial_sum[2] | initial_sum[1]));
    
    // Apply correction using bitwise operations (0110 = 6)
    assign Sum = initial_sum[3:0] + {1'b0, correction_needed, correction_needed, 1'b0};
    
    // Simplified carry generation
    assign Cout = correction_needed;

endmodule