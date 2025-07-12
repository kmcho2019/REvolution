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
    // Sum >9 when: sum[4] OR (sum[3] AND (sum[2] OR sum[1]))
    wire correction_needed = initial_sum[4] | 
                          (initial_sum[3] & (initial_sum[2] | initial_sum[1]));
    
    // Apply correction (0110) using bit manipulation for efficiency
    assign Sum = initial_sum[3:0] ^ {4{correction_needed}} & 4'b0110;
    assign Cout = correction_needed;

endmodule