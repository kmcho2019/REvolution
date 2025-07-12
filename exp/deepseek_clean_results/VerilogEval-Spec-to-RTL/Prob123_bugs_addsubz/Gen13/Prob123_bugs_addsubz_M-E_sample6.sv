module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_modified = b ^ {8{do_sub}};
    wire [7:0] sum = a ^ b_modified;
    wire [7:0] carry = (a & b_modified) << 1;
    wire [7:0] final_sum = sum + carry + do_sub;
    
    // Early zero detection
    wire early_zero = ~(|(sum | carry));
    
    assign out = final_sum;
    assign result_is_zero = early_zero | ~(|final_sum);

endmodule