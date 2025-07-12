module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial binary sum (5-bit to capture overflow)
    wire [4:0] initial_sum = A + B + Cin;
    
    // Generate intermediate carry signals for optimization
    wire carry3 = (A[3] & B[3]) | ((A[3] | B[3]) & (A[2] & B[2])) |
                 ((A[3] | B[3]) & (A[2] | B[2]) & (A[1] & B[1])) |
                 ((A[3] | B[3]) & (A[2] | B[2]) & (A[1] | B[1]) & (A[0] & B[0])) |
                 ((A[3] | B[3]) & (A[2] | B[2]) & (A[1] | B[1]) & (A[0] | B[0]) & Cin);
    
    // Correction needed if sum > 9 or carry generated
    wire correction_needed = (initial_sum[4] | (initial_sum[3] & (initial_sum[2] | initial_sum[1])));
    
    // Apply correction using efficient selection
    assign Sum = correction_needed ? initial_sum[3:0] + 4'd6 : initial_sum[3:0];
    assign Cout = correction_needed;

endmodule