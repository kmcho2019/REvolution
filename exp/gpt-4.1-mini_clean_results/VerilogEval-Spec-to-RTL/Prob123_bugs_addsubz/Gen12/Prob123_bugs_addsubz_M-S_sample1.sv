module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);
    wire [7:0] b_in;
    wire [8:0] sum;

    assign b_in = do_sub ? ~b : b;
    assign sum = {1'b0, a} + {1'b0, b_in} + do_sub;

    always @(*) begin
        out = sum[7:0];
        result_is_zero = (out == 8'b0);
    end
endmodule