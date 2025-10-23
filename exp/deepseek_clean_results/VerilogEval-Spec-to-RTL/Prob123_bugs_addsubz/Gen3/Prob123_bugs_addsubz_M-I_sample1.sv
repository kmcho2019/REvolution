module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_operand = do_sub ? ~b : b;
    wire carry_in = do_sub ? 1'b1 : 1'b0;

    always @(*) begin
        out = a + b_operand + carry_in;
        
        if (|out)
            result_is_zero = 1'b0;
        else
            result_is_zero = 1'b1;
    end

endmodule