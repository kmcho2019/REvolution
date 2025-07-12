module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    reg [7:0] b_inverted;
    reg [7:0] b_to_add;

    always @(*) begin
        // Invert b when do_sub is 1
        b_inverted = do_sub ? ~b : b;
        // Add 1 to b_inverted when do_sub is 1
        b_to_add = do_sub ? (b_inverted + 1) : b_inverted;

        // Perform the addition
        out = a + b_to_add;

        // Set the zero flag
        result_is_zero = (out == 8'b0) ? 1'b1 : 1'b0;
    end

endmodule