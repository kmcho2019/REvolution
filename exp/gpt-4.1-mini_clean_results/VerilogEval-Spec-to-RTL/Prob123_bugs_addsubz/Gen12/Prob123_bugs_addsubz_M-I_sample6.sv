module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] out,
    output wire       result_is_zero
);

    // Perform addition or subtraction using synthesis-friendly operators
    assign out = do_sub ? (a - b) : (a + b);

    // Zero flag asserted when out is all zeros
    assign result_is_zero = ~|out;

endmodule