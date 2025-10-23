module TopModule (
    input do_sub,          // 1 for subtraction, 0 for addition
    input [7:0] a,         // First operand
    input [7:0] b,         // Second operand
    output reg [7:0] out,  // Result of operation
    output reg result_is_zero  // Flag indicating zero result
);

    always @(*) begin
        // Perform addition or subtraction based on do_sub
        case (do_sub)
            1'b0: out = a + b;  // Addition
            1'b1: out = a - b;  // Subtraction
        endcase

        // Set zero flag - explicitly compare to 8'b0 for clarity
        if (out == 8'b0)
            result_is_zero = 1'b1;
        else
            result_is_zero = 1'b0;
    end

endmodule