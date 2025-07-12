module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] out,
    output wire       result_is_zero
);

    // Use conditional operator with '+' and '-' to leverage synthesizer's optimized adder
    assign out = do_sub ? (a - b) : (a + b);

    // Zero flag via reduction NOR on output
    assign result_is_zero = ~|out;

endmodule