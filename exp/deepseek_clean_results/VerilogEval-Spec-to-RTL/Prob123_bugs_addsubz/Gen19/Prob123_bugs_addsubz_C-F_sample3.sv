module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Optimal XOR-based conditional inversion and addition
    wire [7:0] b_operand = b ^ {8{do_sub}};
    wire [7:0] sum = a + b_operand + do_sub;
    
    // Hierarchical zero detection for better timing/power
    wire lower_zero = &(~sum[3:0]);
    wire upper_zero = &(~sum[7:4]);
    
    assign out = sum;
    assign result_is_zero = lower_zero & upper_zero;

endmodule