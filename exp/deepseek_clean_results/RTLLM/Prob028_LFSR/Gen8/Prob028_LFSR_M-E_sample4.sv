module LFSR (
    input wire clk,            // Clock input
    input wire rst,            // Active-high synchronous reset
    output wire [3:0] out     // Current LFSR state in Gray code
);

reg [3:0] state;              // Current binary state
reg [3:0] next_state;        // Predicted next state
wire [3:0] gray_out;          // Gray code converted output
wire feedback;               // Feedback signal

// Parallel feedback calculation for all possible states
// This is essentially a ROM of all possible feedback values
assign feedback = ~(state[3] ^ state[2]);

// Dual-edge triggered state update
always @(posedge clk, negedge clk) begin
    if (rst) begin
        state <= 4'b0001;     // Initialize to non-zero state
    end else begin
        state <= next_state;  // Update state on both edges
    end
end

// Next state prediction (combinational)
always @(*) begin
    next_state = {state[2:0], feedback};
end

// Binary to Gray code conversion
assign gray_out[3] = state[3];
assign gray_out[2] = state[3] ^ state[2];
assign gray_out[1] = state[2] ^ state[1];
assign gray_out[0] = state[1] ^ state[0];

assign out = gray_out;

// Initialize for simulation
initial begin
    state = 4'b0001;
    next_state = 4'b0001;
end

endmodule