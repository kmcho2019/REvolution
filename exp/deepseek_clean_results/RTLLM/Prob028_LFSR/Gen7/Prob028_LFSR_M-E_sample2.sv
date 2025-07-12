module LFSR (
    input clk,
    input rst,
    output [3:0] out,
    output parity,
    output cycle_complete
);

parameter TAPS = 4'b1100; // Configurable tap positions (bits 3 and 2)
reg [3:0] state;
reg [3:0] next_state;
wire feedback;
integer count;

// Gray code state transitions
function [3:0] gray_next;
    input [3:0] current;
    begin
        gray_next = current ^ {1'b0, current[3:1]};
    end
endfunction

// Feedback is XOR of taps (Fibonacci style) with inversion
assign feedback = ~(^(state & TAPS));
assign out = state;
assign parity = ^state; // Parity bit output
assign cycle_complete = (state == 4'b0001); // Full cycle detection

always @(posedge clk or negedge clk or posedge rst) begin
    if (rst) begin
        state <= 4'b0001; // Auto-seed to non-zero value
        count <= 0;
    end
    else begin
        // Dual-edge operation
        state <= gray_next(next_state);
        count <= count + 1;
    end
end

// Hybrid Galois-Fibonacci update
always @(*) begin
    next_state = {state[2:0], feedback}; // Fibonacci shift
    // Galois-style XOR at tap positions
    next_state = next_state ^ (TAPS & {4{feedback}});
end

endmodule