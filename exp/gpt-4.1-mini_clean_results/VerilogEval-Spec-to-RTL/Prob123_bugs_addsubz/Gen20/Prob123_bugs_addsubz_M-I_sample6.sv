module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    wire [7:0] b_inverted;
    wire [7:0] sum;

    assign b_inverted = do_sub ? ~b : b;
    assign sum = a + b_inverted + do_sub;

    always @(*) begin
        out = sum;
        if (sum == 8'b0)
            result_is_zero = 1'b1;
        else
            result_is_zero = 1'b0;
    end

endmodule