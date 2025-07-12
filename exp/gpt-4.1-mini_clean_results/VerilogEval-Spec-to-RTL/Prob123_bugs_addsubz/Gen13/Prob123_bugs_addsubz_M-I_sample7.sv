module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Calculate either addition or subtraction using the built-in '+' and '-'
    assign out = do_sub ? (a - b) : (a + b);

    // Zero flag: high if out is zero
    assign result_is_zero = ~|out;

endmodule