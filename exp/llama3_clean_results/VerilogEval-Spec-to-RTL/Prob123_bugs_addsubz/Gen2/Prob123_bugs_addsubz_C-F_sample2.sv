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

        // Concise and explicit comparison for the zero flag
        result_is_zero = (out == 0) ? 1'b1 : 1'b0;
    end

endmodule