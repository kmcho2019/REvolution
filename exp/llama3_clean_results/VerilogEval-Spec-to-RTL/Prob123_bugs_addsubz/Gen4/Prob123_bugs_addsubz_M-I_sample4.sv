module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output reg result_is_zero
);

    assign out = do_sub ? a - b : a + b;

    always @(*) begin
        result_is_zero = (out[7:0] == 8'd0) ? 1'b1 : 1'b0;
    end

endmodule