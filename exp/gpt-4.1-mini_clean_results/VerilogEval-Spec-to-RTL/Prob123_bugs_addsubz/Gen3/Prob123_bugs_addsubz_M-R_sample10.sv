module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_mux;
    wire [7:0] sum;

    assign b_mux = do_sub ? ~b : b;
    assign sum   = a + b_mux + do_sub;

    assign out = sum;
    assign result_is_zero = (sum == 8'b0);

endmodule