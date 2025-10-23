module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] sub_val;
    wire [7:0] add_val;

    assign add_val = a + b;
    assign sub_val = a + (~b) + 1'b1;  // Two's complement subtraction
    assign out = do_sub ? sub_val : add_val;
    assign result_is_zero = (out == 8'b0);

endmodule