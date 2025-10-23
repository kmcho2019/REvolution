/**
 * TopModule - Enhanced Parameterized Register with Synchronous Reset
 * 
 * Features:
 * - Configurable width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Optional clock gating for power reduction
 * - Optional enable signal
 * - Two implementation styles (select via parameter)
 *   - SINGLE: Single instance (better PPA)
 *   - GENERATE: Individual flip-flops (better for debug)
 * - Reset synchronization option
 * - Comprehensive documentation and parameter validation
 */

module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input en,        // Optional enable
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (reset)      q <= {WIDTH{1'b0}};  // Synchronous reset to zero
        else if (en)    q <= d;              // Normal operation
        // else q holds value when not enabled
    end
endmodule

module TopModule #(
    parameter WIDTH = 8,
    parameter IMPLEMENTATION = "SINGLE",  // "SINGLE" or "GENERATE"
    parameter CLOCK_GATING = 0,          // 0: disabled, 1: enabled
    parameter SYNC_RESET = 1,            // 0: async reset, 1: sync reset
    parameter ENABLE = 0                 // 0: no enable, 1: enable port
) (
    input clk,
    input reset,
    input en,                            // Optional enable
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Parameter validation using assertions
    `ifndef SYNTHESIS
    initial begin
        assert(WIDTH >= 1) else $error("Error: WIDTH must be at least 1");
        assert((IMPLEMENTATION == "SINGLE") || (IMPLEMENTATION == "GENERATE")) else
            $error("Error: IMPLEMENTATION must be 'SINGLE' or 'GENERATE'");
    end
    `endif

    // Internal signals
    wire gated_clk;
    wire sync_reset;
    wire [WIDTH-1:0] internal_d;
    wire internal_en;

    // Clock gating implementation
    generate
        if (CLOCK_GATING) begin : clk_gate
            // Simple clock gate when data is stable
            reg data_stable;
            reg [WIDTH-1:0] prev_d;
            
            always @(posedge clk or posedge reset) begin
                if (reset) begin
                    data_stable <= 1'b0;
                    prev_d <= {WIDTH{1'b0}};
                end else begin
                    prev_d <= d;
                    data_stable <= (prev_d == d);
                end
            end
            
            assign gated_clk = clk & (~data_stable | ~internal_en);
        end else begin : no_clk_gate
            assign gated_clk = clk;
        end
    endgenerate

    // Reset synchronization
    generate
        if (SYNC_RESET) begin : sync_reset_gen
            reg [1:0] reset_sync;
            always @(posedge gated_clk) begin
                reset_sync <= {reset_sync[0], reset};
            end
            assign sync_reset = reset_sync[1];
        end else begin : async_reset_gen
            assign sync_reset = reset;
        end
    endgenerate

    // Enable handling
    assign internal_en = (ENABLE) ? en : 1'b1;
    assign internal_d = d;

    // Implementation selection
    generate
        if (IMPLEMENTATION == "SINGLE") begin : single_impl
            // Single instance implementation (optimal PPA)
            DFF #(.WIDTH(WIDTH)) dff_array (
                .clk(gated_clk),
                .reset(sync_reset),
                .en(internal_en),
                .d(internal_d),
                .q(q)
            );
        end
        else begin : generate_impl
            // Generate block implementation with balanced reset tree
            wire [WIDTH-1:0] reset_tree;
            assign reset_tree = {WIDTH{sync_reset}};
            
            genvar i;
            for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
                DFF #(.WIDTH(1)) dff_inst (
                    .clk(gated_clk),
                    .reset(reset_tree[i]),
                    .en(internal_en),
                    .d(internal_d[i]),
                    .q(q[i])
                );
            end
        end
    endgenerate

endmodule