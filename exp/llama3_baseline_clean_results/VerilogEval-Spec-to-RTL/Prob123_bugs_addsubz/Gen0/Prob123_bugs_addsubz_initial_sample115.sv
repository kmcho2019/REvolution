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

        if (out == 8'b0) // Check if out is equal to zero
            result_is_zero = 1'b1; // Set result_is_zero to 1 if out is zero
        else
            result_is_zero = 1'b0; // Set result_is_zero to 0 if out is not zero
    end

endmodule