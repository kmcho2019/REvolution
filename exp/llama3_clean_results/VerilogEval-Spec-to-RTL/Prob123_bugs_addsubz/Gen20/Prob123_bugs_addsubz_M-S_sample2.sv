module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    assign out = do_sub? (a - b) : (a + b);
    assign result_is_zero = ~(| out);

endmodule