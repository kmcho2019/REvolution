module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_neg = ~b + 1'b1;  // Two's complement of b
    wire [7:0] sum = a + b;
    wire [7:0] diff = a + b_neg;

    always @(*) begin
        out = do_sub ? diff : sum;
        result_is_zero = ~(|out);  // Reduction NOR for zero detection
    end

endmodule