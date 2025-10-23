module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_invert;
    assign b_invert = do_sub? ~b : b;

    wire [7:0] sum;
    assign sum = do_sub? a - b : a + b;

    assign out = sum;
    assign result_is_zero = ~(|sum); // Check if all bits are zero

endmodule