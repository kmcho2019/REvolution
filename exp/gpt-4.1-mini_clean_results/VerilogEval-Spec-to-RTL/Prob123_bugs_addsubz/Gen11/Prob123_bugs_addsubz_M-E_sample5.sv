module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg [7:0] b_neg;

    always @(*) begin
        // Compute b_neg as two's complement of b when do_sub is 1, else just b
        b_neg = do_sub ? (~b + 8'd1) : b;

        // Perform addition or subtraction implicitly by adding b_neg
        out = a + b_neg;

        // Set zero flag using reduction NOR on the result
        result_is_zero = ~|out;
    end

endmodule