module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    // Calculate the two's complement of b if do_sub is 1
    wire [7:0] b_signed;
    assign b_signed = do_sub ? (~b + 1) : b;

    // Perform addition
    assign out = a + b_signed;

    // Check if the result is zero
    always @(*) begin
        result_is_zero = (out == 8'b0) ? 1'b1 : 1'b0;
    end

endmodule