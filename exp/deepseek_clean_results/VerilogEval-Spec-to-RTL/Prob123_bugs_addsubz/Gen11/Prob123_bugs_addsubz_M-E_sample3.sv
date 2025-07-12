module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Compute both addition and subtraction in parallel
    wire [7:0] sum = a + b;
    wire [7:0] diff = a - b;

    // Select the appropriate result
    assign out = do_sub ? diff : sum;

    // Zero detection
    assign result_is_zero = (out == 8'b0);

endmodule