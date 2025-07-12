module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial binary sum (5-bit to capture overflow)
    wire [4:0] initial_sum = A + B + Cin;
    
    /* Correction needed when:
       1. Sum > 9 (binary 1001) -> pattern 1XXX or X1X1 (where X is don't care)
       2. Carry generated (initial_sum[4] = 1)
       This is equivalent to checking if the 4-bit sum is >9 OR if there's a carry
    */
    wire correction_needed = (initial_sum[3:0] > 4'd9) | initial_sum[4];
    
    /* Apply correction:
       When needed: sum = initial_sum + 6 (0110)
       When not needed: sum = initial_sum
       Implemented efficiently using bitwise operations
    */
    wire [3:0] corrected_sum = initial_sum[3:0] + {1'b0, correction_needed, correction_needed, 1'b0};
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = correction_needed;

endmodule