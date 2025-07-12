module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        // Perform addition or subtraction based on control signal
        case (do_sub)
            1'b0: out = a + b;
            1'b1: out = a - b;
        endcase

        // Set zero flag (complete assignment prevents latches)
        result_is_zero = (out == 8'b0);
    end

    /* Optimization Notes:
     * 1. For synchronous implementations: Consider registered outputs
     * 2. For variable width: Parameterize the bit width
     * 3. For power: Add enable signal if continuous operation not needed
     */

endmodule