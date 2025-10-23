module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    reg [7:0] sum;

    always @(*) begin
        if (do_sub)
            sum = a + (~b) + 1;
        else
            sum = a + b;

        out = sum;

        if (sum == 8'b0)
            result_is_zero = 1'b1;
        else
            result_is_zero = 1'b0;
    end

endmodule