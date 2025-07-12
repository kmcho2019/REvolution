module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Next state calculation (combinational logic)
wire [63:0] next_state = {~Q[0], Q[63:1]};

// State update (sequential logic)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low synchronous reset
    end else begin
        Q <= next_state;  // Johnson counter state transition
    end
end

/* State Transition Explanation:
 * When Q[0] is 0: next_state = {1'b1, Q[63:1]} (shift right with 1)
 * When Q[0] is 1: next_state = {1'b0, Q[63:1]} (shift right with 0)
 * This creates the characteristic Johnson counter pattern
 */

endmodule