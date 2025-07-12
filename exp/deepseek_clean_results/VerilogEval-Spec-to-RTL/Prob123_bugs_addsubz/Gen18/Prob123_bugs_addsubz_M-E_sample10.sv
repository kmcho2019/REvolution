module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] sum = a + b;
    wire [7:0] diff = a - b;
    wire sum_zero = ~(|sum);
    wire diff_zero = ~(|diff);

    always @(*) begin
        out = do_sub ? diff : sum;
        result_is_zero = do_sub ? diff_zero : sum_zero;
    end

endmodule