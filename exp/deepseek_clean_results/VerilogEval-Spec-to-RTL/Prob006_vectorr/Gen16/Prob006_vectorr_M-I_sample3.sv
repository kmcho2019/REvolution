/*
 * BitReverser - Power-optimized parameterized bit reversal module
 * Uses combinational always block for better power characteristics
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector to reverse
 *   out - Output with reversed bit order
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

    // Combinational always block for power efficiency
    always @(*) begin
        for (int i = 0; i < WIDTH; i = i + 1) begin
            out[i] = in[WIDTH-1-i];
        end
    end

endmodule

/*
 * TopModule - Wrapper maintaining original 8-bit interface
 * Provides clean interface while allowing internal parameterization
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate power-optimized reverser with default width
    BitReverser reverser (
        .in(in),
        .out(out)
    );

endmodule