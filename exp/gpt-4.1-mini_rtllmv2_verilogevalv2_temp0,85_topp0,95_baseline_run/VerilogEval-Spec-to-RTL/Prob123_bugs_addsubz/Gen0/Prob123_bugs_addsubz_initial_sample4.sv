module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        case (do_sub)
            0: out = a + b;
            1: out = a - b;
        endcase

        // Assign result_is_zero in all cases to avoid latching
        if (out == 8'b0)
            result_is_zero = 1;
        else
            result_is_zero = 0;
    end

endmodule