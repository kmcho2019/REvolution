module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_selector;
    assign b_selector = do_sub? (~b + 1) : b;

    assign out = a + b_selector;
    assign result_is_zero = ~(| out);

endmodule