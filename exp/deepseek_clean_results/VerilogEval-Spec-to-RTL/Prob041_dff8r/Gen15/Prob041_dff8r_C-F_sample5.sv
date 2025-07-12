/**
 * TopModule - Optimized Register Bank with Synchronous Reset
 * 
 * Features:
 * - Configurable width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Two optimized implementation styles:
 *   - "SINGLE": Single instance (optimal PPA - default)
 *   - "GENERATE": Individual flip-flops (debug friendly)
 * - Comprehensive documentation and parameter validation
 */

module TopModule #(
    parameter WIDTH = 8,
    parameter IMPLEMENTATION = "SINGLE"  // "SINGLE" (default) or "GENERATE"
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    // Parameter validation
    initial begin
        if (WIDTH < 1) begin
            $error("Error: WIDTH must be at least 1 (given %0d)", WIDTH);
        end
        if (IMPLEMENTATION != "SINGLE" && IMPLEMENTATION != "GENERATE") begin
            $error("Error: IMPLEMENTATION must be 'SINGLE' or 'GENERATE' (given '%0s')", 
                  IMPLEMENTATION);
        end
    end

    // Implementation selection
    generate
        if (IMPLEMENTATION == "SINGLE") begin : single_impl
            // Optimal PPA implementation - single always block
            always @(posedge clk) begin
                if (reset) q <= {WIDTH{1'b0}};
                else       q <= d;
            end
        end
        else begin : generate_impl
            // Debug-friendly implementation - individual flip-flops
            always @(posedge clk) begin
                for (int i = 0; i < WIDTH; i++) begin
                    if (reset) q[i] <= 1'b0;
                    else       q[i] <= d[i];
                end
            end
        end
    endgenerate

endmodule