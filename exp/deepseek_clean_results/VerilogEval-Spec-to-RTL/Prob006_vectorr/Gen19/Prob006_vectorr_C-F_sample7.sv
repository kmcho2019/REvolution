/*
 * BitReverser - Optimized bit reversal module with automatic implementation selection
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width (must be > 0)
 * Features:
 *   - Uses direct assignments for WIDTH=8 (optimal implementation)
 *   - Uses generate loop for other widths (flexible implementation)
 *   - Pure combinational logic
 *   - Parameter validation
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Validate parameter
    initial begin
        if (WIDTH <= 0) begin
            $error("BitReverser: WIDTH must be positive (given %0d)", WIDTH);
        end
    end

    // Special optimized implementation for 8-bit case
    `ifdef OPTIMIZE_8BIT
    generate
        if (WIDTH == 8) begin : OPT_8BIT
            // Direct bit assignments for optimal 8-bit implementation
            assign out[0] = in[7];
            assign out[1] = in[6];
            assign out[2] = in[5];
            assign out[3] = in[4];
            assign out[4] = in[3];
            assign out[5] = in[2];
            assign out[6] = in[1];
            assign out[7] = in[0];
        end
        else begin : GEN_BITREV
    `endif
            // General implementation using generate loop
            genvar i;
            for (i = 0; i < WIDTH; i = i + 1) begin : BIT_REV
                assign out[i] = in[WIDTH-1-i];
            end
    `ifdef OPTIMIZE_8BIT
        end
    endgenerate
    `endif

endmodule

/*
 * TopModule - Wrapper maintaining original 8-bit interface
 * Uses the optimized BitReverser internally
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate with optimized 8-bit implementation
    BitReverser #(
        .WIDTH(8)
    ) reverser (
        .in(in),
        .out(out)
    );

endmodule