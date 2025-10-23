module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_signed;

    // Calculate the two's complement of b if do_sub is 1
    assign b_signed = do_sub ? (~b + 1) : b;

    // Perform addition
    always @(*) begin
        out = a + b_signed;

        // Check if the result is zero
        if (out == 8'b0)
            result_is_zero = 1'b1;
        else
            result_is_zero = 1'b0;
    end

endmodule