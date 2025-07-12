/**
 * Enhanced Parameterized D Flip-Flop with Synchronous Reset
 * Features:
 * - Configurable width and reset polarity
 * - Optional clock gating
 * - Reset synchronizer
 * - Optional output buffering
 */
module DFF #(
    parameter WIDTH = 1,
    parameter RESET_POLARITY = 1'b1,  // 1=active high, 0=active low
    parameter CLOCK_GATING = 0,       // Enable clock gating
    parameter OUTPUT_BUFFER = 0       // Add output register
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    reg [WIDTH-1:0] q_int;
    reg reset_sync;
    wire gated_clk;
    wire effective_reset = RESET_POLARITY ? reset_sync : ~reset_sync;

    // Reset synchronizer (2-FF)
    always @(posedge clk) begin
        reset_sync <= reset;
    end

    // Clock gating logic
    generate if (CLOCK_GATING) begin : gen_clk_gate
        reg [WIDTH-1:0] d_prev;
        wire clk_en = (d != d_prev);
        
        always @(posedge clk) begin
            d_prev <= d;
        end
        
        assign gated_clk = clk & clk_en;
    end else begin : gen_no_clk_gate
        assign gated_clk = clk;
    end
    endgenerate

    // Main flip-flop
    always @(posedge gated_clk) begin
        if (effective_reset) q_int <= {WIDTH{1'b0}};
        else                q_int <= d;
    end

    // Optional output buffer
    generate if (OUTPUT_BUFFER) begin : gen_out_buf
        reg [WIDTH-1:0] q_buf;
        always @(posedge gated_clk) begin
            q_buf <= q_int;
        end
        assign q = q_buf;
    end else begin : gen_no_out_buf
        assign q = q_int;
    end
    endgenerate

endmodule

/**
 * Optimized Top Module with 8-bit Register
 * Uses enhanced DFF with:
 * - Clock gating disabled (balance between power and performance)
 * - Output buffering disabled (not needed for this case)
 * - Standard active high reset
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    DFF #(
        .WIDTH(8),
        .RESET_POLARITY(1'b1),
        .CLOCK_GATING(0),
        .OUTPUT_BUFFER(0)
    ) dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule