module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Modified operand for subtraction (bitwise inversion)
    wire [7:0] modified_b = b ^ {8{do_sub}};
    
    // Carry-save addition components
    wire [7:0] sum = a ^ modified_b;
    wire [7:0] carry = (a & modified_b) << 1;
    
    // Final addition with carry-in for subtraction
    wire [8:0] full_result = sum + carry + do_sub;
    
    // Output assignment
    assign out = full_result[7:0];
    
    // Early zero detection using parallel NOR
    wire [7:0] zero_check = sum ^ carry;
    assign result_is_zero = ~(|zero_check) & ~full_result[8];

endmodule