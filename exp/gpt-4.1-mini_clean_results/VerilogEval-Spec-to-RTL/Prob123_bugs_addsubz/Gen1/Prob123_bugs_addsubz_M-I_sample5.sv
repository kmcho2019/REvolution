module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_mux;
    wire [7:0] sum;

    // If do_sub is 1, invert b for two's complement subtraction
    assign b_mux = do_sub ? ~b : b;

    // Add a and b_mux, plus 1 if do_sub is 1 (for two's complement)
    assign sum = a + b_mux + do_sub;

    always @(*) begin
        out = sum;
        result_is_zero = (sum == 8'b0);
    end

endmodule