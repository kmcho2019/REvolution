module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Two's complement conversion for subtraction
    wire [7:0] b_inverted = b ^ {8{do_sub}};
    wire [7:0] b_final = b_inverted + do_sub;
    
    // Main adder
    wire [7:0] sum = a + b_final;
    
    // Zero detection using reduction NOR
    assign result_is_zero = ~(|sum);
    
    // Output assignment
    assign out = sum;

endmodule