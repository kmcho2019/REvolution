module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Select between addition and subtraction
    assign out = do_sub ? (a - b) : (a + b);
    
    // Zero detection using reduction NOR (more area-efficient)
    assign result_is_zero = ~(|out);

endmodule