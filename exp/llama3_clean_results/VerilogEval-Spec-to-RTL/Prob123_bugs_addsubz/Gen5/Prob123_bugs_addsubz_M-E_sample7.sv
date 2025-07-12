module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] add_result;
    wire [7:0] sub_result;

    assign add_result = a + b;
    assign sub_result = a - b;

    always @(*) begin
        out = do_sub? sub_result : add_result;
        result_is_zero = (out == 8'd0)? 1'b1 : 1'b0;
    end

endmodule