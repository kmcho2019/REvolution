module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,    // First operand
    input wire [N-1:0] b,    // Second operand
    output wire [N-1:0] c    // Subtraction result
);

    // Parameter validation
    initial begin
        if (Q > N) begin
            $error("Invalid parameters: Q (%0d) must be <= N (%0d)", Q, N);
        end
    end

    // Perform signed subtraction - automatically handles:
    // - Same sign subtraction
    // - Different sign subtraction
    // - Zero result (which will have sign bit 0 in two's complement)
    assign c = $signed(a) - $signed(b);

endmodule