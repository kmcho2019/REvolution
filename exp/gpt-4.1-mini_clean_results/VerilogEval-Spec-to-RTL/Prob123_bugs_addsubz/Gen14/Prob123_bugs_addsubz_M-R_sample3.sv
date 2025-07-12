module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Perform addition or subtraction based on do_sub
    assign out = do_sub ? (a - b) : (a + b);

    // Combinational zero flag detection
    assign result_is_zero = (out == 8'b0);

endmodule