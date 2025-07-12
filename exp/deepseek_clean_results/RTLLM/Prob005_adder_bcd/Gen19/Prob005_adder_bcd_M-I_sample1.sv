module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Carry-save initial sum calculation
    wire [3:0] sum_lsb = A[2:0] + B[2:0] + Cin;
    wire [3:0] sum_msb = A[3] + B[3] + sum_lsb[3];
    
    // Combine partial sums
    wire [3:0] initial_sum = {sum_msb[0], sum_lsb[2:0]};
    wire carry_out = sum_msb[1];

    // Optimized >9 check using LUT-friendly logic
    wire correction_needed = carry_out | 
                           (initial_sum[3] & (initial_sum[2] | initial_sum[1]));

    // Efficient correction application using bitwise operations
    wire [3:0] correction = {1'b0, correction_needed, correction_needed, 1'b0};
    wire [3:0] corrected_sum = initial_sum + correction;
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = correction_needed;

endmodule