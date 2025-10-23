/**
 * Enhanced Parameterized D Flip-Flop with Synchronous Reset
 * Features:
 * - Configurable width (default 1 bit)
 * - Positive edge-triggered
 * - Synchronous active-high reset
 * - Optional clock gating
 * - Optional enable signal
 */
module DFF #(
    parameter WIDTH = 1,
    parameter USE_CLOCK_GATING = 0,  // 0: disabled, 1: enabled
    parameter USE_ENABLE = 0        // 0: disabled, 1: enabled
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q,
    input en = 1'b1                 // Optional enable (default always on)
);

    // Internal clock signal
    wire gated_clk;
    generate
        if (USE_CLOCK_GATING) begin : clk_gate
            // Clock gating when input data is stable
            wire clk_en = (reset || (|(d ^ q)) || (USE_ENABLE && en);
            assign gated_clk = clk & clk_en;
        end
        else begin : no_clk_gate
            assign gated_clk = clk;
        end
    endgenerate

    always @(posedge gated_clk) begin
        if (reset) q <= {WIDTH{1'b0}};          // Synchronous reset
        else if (!USE_ENABLE || en) q <= d;      // Conditional update
    end

endmodule

/**
 * Top Module - Enhanced 8-bit Register
 * Features:
 * - Configurable implementation style
 * - Optional clock gating
 * - Optional enable signal
 * - Comprehensive parameter validation
 * - Optimal PPA by default
 */
module TopModule #(
    parameter IMPLEMENTATION = "SINGLE",  // "SINGLE" or "GENERATE"
    parameter USE_CLOCK_GATING = 0,       // 0: disabled, 1: enabled
    parameter USE_ENABLE = 0              // 0: disabled, 1: enabled
) (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q,
    input en = 1'b1                       // Optional enable (default always on)
);

    // Parameter validation
    initial begin
        if (IMPLEMENTATION != "SINGLE" && IMPLEMENTATION != "GENERATE") begin
            $error("Error: IMPLEMENTATION must be 'SINGLE' or 'GENERATE'");
        end
        if (USE_CLOCK_GATING != 0 && USE_CLOCK_GATING != 1) begin
            $error("Error: USE_CLOCK_GATING must be 0 or 1");
        end
        if (USE_ENABLE != 0 && USE_ENABLE != 1) begin
            $error("Error: USE_ENABLE must be 0 or 1");
        end
    end

    // Implementation selection
    generate
        if (IMPLEMENTATION == "SINGLE") begin : single_impl
            // Single instance implementation (optimal PPA)
            DFF #(
                .WIDTH(8),
                .USE_CLOCK_GATING(USE_CLOCK_GATING),
                .USE_ENABLE(USE_ENABLE)
            ) dff_array (
                .clk(clk),
                .reset(reset),
                .d(d),
                .q(q),
                .en(en)
            );
        end
        else begin : generate_impl
            // Generate block implementation (debug friendly)
            genvar i;
            for (i = 0; i < 8; i = i + 1) begin : dff_gen
                DFF #(
                    .WIDTH(1),
                    .USE_CLOCK_GATING(USE_CLOCK_GATING),
                    .USE_ENABLE(USE_ENABLE)
                ) dff_inst (
                    .clk(clk),
                    .reset(reset),
                    .d(d[i]),
                    .q(q[i]),
                    .en(en)
                );
            end
        end
    endgenerate

endmodule