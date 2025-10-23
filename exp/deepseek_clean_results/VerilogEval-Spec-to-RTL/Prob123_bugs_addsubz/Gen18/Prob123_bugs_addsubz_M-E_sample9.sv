module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    // Early zero prediction
    wire potential_zero_add = &(a ^ ~b);  // a + b = -1 (all 1s)
    wire potential_zero_sub = &(a ^ b);   // a - b = 0
    wire potential_zero = do_sub ? potential_zero_sub : potential_zero_add;

    // Carry-save addition
    wire [7:0] b_operand = b ^ {8{do_sub}};
    wire [7:0] sum = a + b_operand + do_sub;
    
    // Final zero detection
    wire actual_zero = ~(|sum);
    
    always @(*) begin
        out = sum;
        // Combine prediction with actual result
        result_is_zero = potential_zero ? 1'b1 : actual_zero;
        
        // Power optimization: when predicted zero, could gate the adder
        // (implementation depends on synthesis constraints)
    end

endmodule