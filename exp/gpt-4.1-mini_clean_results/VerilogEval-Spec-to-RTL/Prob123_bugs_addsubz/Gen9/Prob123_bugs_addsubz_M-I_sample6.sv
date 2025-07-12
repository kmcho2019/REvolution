module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Use native Verilog addition/subtraction operator for optimized synthesis
    assign out = do_sub ? (a - b) : (a + b);

    // Zero flag is 1 if out is zero
    assign result_is_zero = ~|out;

endmodule