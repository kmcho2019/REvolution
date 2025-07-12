/**
 * Optimized TopModule - Parameterized Register with Synchronous Reset
 * 
 * Enhanced Features:
 * - Configurable width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Two implementation styles (select via parameter)
 *   - SINGLE: Single instance (better PPA)
 *   - GENERATE: Individual flip-flops (better for debug)
 * - Optional clock gating when data is stable
 * - Optional enable signal for power savings
 * - Banked reset structure for wide registers
 * - Assertion-based parameter validation
 */

module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input en,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (reset)      q <= {WIDTH{1'b0}};  // Synchronous reset to zero
        else if (en)    q <= d;              // Normal operation with enable
        // else q holds value when not enabled
    end
endmodule

module TopModule #(
    parameter WIDTH = 8,
    parameter IMPLEMENTATION = "SINGLE",  // "SINGLE" or "GENERATE"
    parameter USE_ENABLE = 0,             // 0 or 1
    parameter USE_CLOCK_GATING = 0,       // 0 or 1
    parameter RESET_BANKS = 1             // Number of reset banks (1 for no banking)
) (
    input clk,
    input reset,
    input en,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Parameter validation using assertions
    `ifndef SYNTHESIS
    initial begin
        assert(WIDTH >= 1) else $error("Error: WIDTH must be at least 1");
        assert((IMPLEMENTATION == "SINGLE") || (IMPLEMENTATION == "GENERATE")) 
            else $error("Error: IMPLEMENTATION must be 'SINGLE' or 'GENERATE'");
        assert(RESET_BANKS >= 1 && RESET_BANKS <= WIDTH) 
            else $error("Error: RESET_BANKS must be between 1 and WIDTH");
    end
    `endif

    // Clock gating logic
    wire gated_clk;
    reg [WIDTH-1:0] prev_d;
    wire clk_enable = USE_CLOCK_GATING ? (prev_d != d) : 1'b1;
    assign gated_clk = clk & (USE_CLOCK_GATING ? clk_enable : 1'b1);
    
    always @(posedge clk) begin
        prev_d <= d;
    end

    // Banked reset signals
    wire [RESET_BANKS-1:0] banked_reset;
    generate
        if (RESET_BANKS > 1) begin : reset_banking
            integer i;
            for (i = 0; i < RESET_BANKS; i = i + 1) begin
                assign banked_reset[i] = reset;
            end
        end else begin
            assign banked_reset[0] = reset;
        end
    endgenerate

    // Implementation selection
    generate
        if (IMPLEMENTATION == "SINGLE") begin : single_impl
            // Single instance implementation (optimal PPA)
            DFF #(.WIDTH(WIDTH)) dff_array (
                .clk(gated_clk),
                .reset(banked_reset[0]),
                .en(USE_ENABLE ? en : 1'b1),
                .d(d),
                .q(q)
            );
        end
        else begin : generate_impl
            // Generate block implementation (debug friendly) with balanced reset
            genvar i;
            for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
                DFF #(.WIDTH(1)) dff_inst (
                    .clk(gated_clk),
                    .reset(banked_reset[i % RESET_BANKS]),
                    .en(USE_ENABLE ? en : 1'b1),
                    .d(d[i]),
                    .q(q[i])
                );
            end
        end
    endgenerate

endmodule