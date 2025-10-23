module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    assign out = do_sub ? a - b : a + b;
    assign result_is_zero = (out == 8'd0);

endmodule