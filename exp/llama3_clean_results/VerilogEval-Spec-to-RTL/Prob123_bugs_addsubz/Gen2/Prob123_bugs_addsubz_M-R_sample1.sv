module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    assign out = (do_sub == 1'b0) ? (a + b) : (a - b);
    assign result_is_zero = (~out) ? 1'b1 : 1'b0;

endmodule