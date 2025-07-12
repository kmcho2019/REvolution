module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output reg result_is_zero
);

    // Arithmetic operation with continuous assignment
    assign out = do_sub ? (a - b) : (a + b);

    // Zero flag with explicit handling
    always @(*) begin
        if (out == 8'b0)
            result_is_zero = 1'b1;
        else
            result_is_zero = 1'b0;
    end

endmodule