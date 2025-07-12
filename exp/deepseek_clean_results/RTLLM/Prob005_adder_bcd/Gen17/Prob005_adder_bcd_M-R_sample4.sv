module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Intermediate sum including carry
    wire [4:0] sum_ext = A + B + Cin;
    
    // Overflow conditions
    wire has_carry = sum_ext[4];
    wire digit_gt9 = (sum_ext[3:0] > 4'd9);
    
    // Combined overflow detection
    wire needs_correction = has_carry | digit_gt9;
    
    // Apply correction if needed
    wire [3:0] corrected_sum = needs_correction ? 
                             (sum_ext[3:0] + 4'd6) : 
                             sum_ext[3:0];
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = needs_correction;

endmodule