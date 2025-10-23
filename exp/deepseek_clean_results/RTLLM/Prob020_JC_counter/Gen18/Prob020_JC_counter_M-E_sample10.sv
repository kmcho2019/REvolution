module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Stage 1: Combinational next state calculation
wire [63:0] next_state;
wire next_msb = ~Q[0];  // Anticipate next MSB value

// Parallel state generation - more hardware but better timing
assign next_state = {next_msb, Q[63:1]};

// Power gating control
wire all_ones = &Q;      // All bits are 1
wire all_zeros = ~|Q;    // All bits are 0
wire stable_state = all_ones | all_zeros;
wire counter_enable = !stable_state || !rst_n;

// Stage 2: Registered output with conditional update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset
    end
    else if (counter_enable) begin
        Q <= next_state;  // Update only when needed
    end
    // Hold value during stable states to save power
end

// Synthesis directives for optimization
// synthesis attribute async_reg of Q is "true";
// synthesis attribute keep_hierarchy of next_state is "true";
// synthesis attribute preserve of next_msb is "true";

/* Power Optimization Notes:
 * - Counter only updates when not in stable states (all 1s or 0s)
 * - Parallel calculation reduces critical path
 * - Next MSB is pre-calculated for faster propagation
 *
 * Timing Considerations:
 * - Pipeline stage 1: next_state calculation (combinational)
 * - Pipeline stage 2: register update (sequential)
 * - Total latency: 1 cycle, but with better timing slack
 */

endmodule