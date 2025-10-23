module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry out
    wire [3:0] sum_low = A + B + Cin;
    wire carry_low = (A + B + Cin) > 4'd9;

    // Pre-compute corrected sum (sum_low + 6)
    wire [3:0] sum_high = sum_low + 4'd6;
    
    // Optimized correction condition: sum >9 or carry
    // Equivalent to: sum[3]&(sum[2]|sum[1]) | (A+B+Cin >15)
    wire correction_needed = (sum_low[3] & (sum_low[2] | sum_low[1])) | 
                           ((A[3] & B[3]) | 
                           ((A[2] | B[2]) & (A[1] | B[1]) & (A[0] | B[0]) & Cin));

    // Select between corrected and uncorrected sum
    assign Sum = correction_needed ? sum_high : sum_low;
    assign Cout = correction_needed;

    // Power optimization: gate the correction logic when inputs are 0
    // (In real implementation would use power gating cells)
    // wire correction_active = |A | |B | Cin;
    // assign Sum = correction_active ? (correction_needed ? sum_high : sum_low) : 4'b0;
    // assign Cout = correction_active & correction_needed;
endmodule