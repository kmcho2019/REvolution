module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] current_state;
reg [2:0] state_counter; // 3 bits are enough to represent 8 states (0 to 7)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 8'b0000_0001; // Initialize to the starting state
        state_counter <= 0; // Reset the state counter
    end else begin
        if (state_counter == 7) begin // If we're at the last state
            state_counter <= 0; // Wrap around to the first state
        end else begin
            state_counter <= state_counter + 1; // Move to the next state
        end
        current_state <= 1 << state_counter; // Update the current state
    end
end

assign out = current_state;

endmodule