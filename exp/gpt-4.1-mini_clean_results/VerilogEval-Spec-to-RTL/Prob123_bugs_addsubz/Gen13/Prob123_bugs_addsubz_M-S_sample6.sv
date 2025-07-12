module TopModule (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       do_sub,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    always @(*) begin
        out = do_sub ? (a - b) : (a + b);
        result_is_zero = (~|out) ? 1'b1 : 1'b0;
    end

endmodule