module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    reg [8:0] wide_result;

    always @(*) begin
        if (do_sub)
            wide_result = {1'b0, a} - {1'b0, b};
        else
            wide_result = {1'b0, a} + {1'b0, b};

        out = wide_result[7:0];
        result_is_zero = (wide_result == 9'b0);
    end

endmodule