/**
 * Enhanced DFF Array with Configurable Features
 * 
 * Features:
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset
 * - Optional clock enable (disabled by default)
 * - Two implementation styles (array or generate)
 * - Power optimization through clock gating
 * - Comprehensive parameter validation
 */

module DFF #(
    parameter WIDTH = 1,
    parameter ENABLE_CLK_GATING = 0  // 0 = disabled, 1 = enabled
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q,
    input clk_en = 1'b1  // Optional clock enable (default always enabled)
);

    wire gated_clk_en;
    
    generate
        if (ENABLE_CLK_GATING) begin
            assign gated_clk_en = clk_en;
        end else begin
            assign gated_clk_en = 1'b1;
        end
    endgenerate

    always @(posedge clk) begin
        if (reset) q <= {WIDTH{1'b0}};
        else if (gated_clk_en) q <= d;
    end

endmodule

module TopModule #(
    parameter WIDTH = 8,
    parameter IMPLEMENTATION = "ARRAY",  // "ARRAY" or "GENERATE"
    parameter ENABLE_CLK_GATING = 0      // 0 = disabled, 1 = enabled
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q,
    input clk_en = 1'b1  // Optional clock enable
);

    // Parameter validation
    initial begin
        if (WIDTH < 1) $error("WIDTH must be at least 1");
        if (IMPLEMENTATION != "ARRAY" && IMPLEMENTATION != "GENERATE") begin
            $error("IMPLEMENTATION must be either 'ARRAY' or 'GENERATE'");
        end
        if (ENABLE_CLK_GATING != 0 && ENABLE_CLK_GATING != 1) begin
            $error("ENABLE_CLK_GATING must be either 0 or 1");
        end
    end

    generate
        if (IMPLEMENTATION == "ARRAY") begin : array_impl
            // Single array implementation (better PPA)
            DFF #(
                .WIDTH(WIDTH),
                .ENABLE_CLK_GATING(ENABLE_CLK_GATING)
            ) dff_array (
                .clk(clk),
                .reset(reset),
                .d(d),
                .q(q),
                .clk_en(clk_en)
            );
        end
        else begin : generate_impl
            // Individual flip-flop implementation (better for debugging)
            genvar i;
            for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
                DFF #(
                    .WIDTH(1),
                    .ENABLE_CLK_GATING(ENABLE_CLK_GATING)
                ) dff_inst (
                    .clk(clk),
                    .reset(reset),
                    .d(d[i]),
                    .q(q[i]),
                    .clk_en(clk_en)
                );
            end
        end
    endgenerate

endmodule