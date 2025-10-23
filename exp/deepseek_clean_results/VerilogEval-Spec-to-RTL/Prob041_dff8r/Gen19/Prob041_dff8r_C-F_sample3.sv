/**
 * TopModule - Optimized Parameterized Register with Synchronous Reset
 *
 * Features:
 * - Configurable data width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Two implementation styles:
 *   - "SINGLE": Single instance (optimal PPA - default)
 *   - "GENERATE": Individual flip-flops (debug friendly)
 * - Comprehensive parameter validation
 * - Optimal power and area characteristics
 */

module DFF #(
    parameter WIDTH = 1  // Data width in bits
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        q <= reset ? {WIDTH{1'b0}} : d;  // Efficient synchronous reset
    end
endmodule

module TopModule #(
    parameter DATA_WIDTH = 8,          // Register width (default 8 bits)
    parameter IMPL_STYLE = "SINGLE"    // "SINGLE" or "GENERATE"
) (
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] d,
    output [DATA_WIDTH-1:0] q
);

    // Parameter validation
    initial begin
        if (DATA_WIDTH < 1) begin
            $error("Error: DATA_WIDTH must be at least 1");
        end
        if (IMPL_STYLE != "SINGLE" && IMPL_STYLE != "GENERATE") begin
            $error("Error: IMPL_STYLE must be 'SINGLE' or 'GENERATE'");
        end
    end

    // Implementation selection
    generate
        if (IMPL_STYLE == "SINGLE") begin : single_impl
            // Optimal PPA implementation - single instance
            DFF #(.WIDTH(DATA_WIDTH)) dff_array (
                .clk(clk),
                .reset(reset),
                .d(d),
                .q(q)
            );
        end
        else begin : generate_impl
            // Debug-friendly implementation - individual flip-flops
            genvar i;
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin : bit_slice
                DFF #(.WIDTH(1)) dff_bit (
                    .clk(clk),
                    .reset(reset),
                    .d(d[i]),
                    .q(q[i])
                );
            end
        end
    endgenerate

endmodule