module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        // Adder/subtractor operation
        case (do_sub)
          0: out = a + b;
          1: out = a - b;
        endcase

        // Zero flag generation
        if (out == 8'b0)
            result_is_zero = 1;
        else
            result_is_zero = 0;
    end

    /* Potential Optimizations:
     * 1. For synchronous systems: Consider clock gating the adder/subtractor
     * 2. For area reduction: Explore resource sharing between adder/subtractor
     * 3. For power: Register the zero flag if timing allows
     */

endmodule