module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    reg [7:0] b_inverted;

    always @(*) begin
        // Invert all bits of b if do_sub is 1
        b_inverted = do_sub? ~b : b;

        // Add 1 to b_inverted if do_sub is 1 (two's complement)
        out = a + (do_sub? (b_inverted + 1) : b_inverted);

        // Check if the result is zero
        result_is_zero = (out == 8'd0)? 1'b1 : 1'b0;
    end

endmodule