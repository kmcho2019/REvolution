module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] add_result = a + b;
    wire [7:0] sub_result = a - b;
    
    assign out = do_sub ? sub_result : add_result;
    assign result_is_zero = (out == 8'b0);

endmodule