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

        if (out == 0)
            result_is_zero = 1'b1; // Set result_is_zero to 1 when out is 0
        else
            result_is_zero = 1'b0; // Reset result_is_zero to 0 when out is not 0
    end

endmodule