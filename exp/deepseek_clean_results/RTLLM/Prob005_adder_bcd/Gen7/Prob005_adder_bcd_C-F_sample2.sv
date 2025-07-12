module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial binary sum (5-bit to capture overflow)
    wire [4:0] initial_sum = A + B + Cin;
    
    // Correction needed if sum > 9 or carry generated
    // Optimized comparison: sum[4] OR (sum[3] AND (sum[2] OR sum[1]))
    wire correction_needed = (initial_sum > 9) | initial_sum[4];
    
    // Apply correction (either +0 or +6) using efficient masking
    wire [3:0] corrected_sum = initial_sum[3:0] + (correction_needed ? 4'd6 : 4'd0);
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = correction_needed;

endmodule