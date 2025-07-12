module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg [7:0] arithmetic_result;

    always @(*) begin
        arithmetic_result = do_sub ? (a - b) : (a + b);
        out = arithmetic_result;
        result_is_zero = (arithmetic_result == 8'b0) ? 1'b1 : 1'b0;
    end

endmodule