module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

// Initialize the state to the starting condition (LSB set to 1) when reset is high
always @(posedge reset) begin
    state <= 8'b0000_0001;
end

// Update the state on each rising edge of the clock signal
always @(posedge clk or negedge reset) begin
    if (~reset) begin
        state <= 8'b0000_0001; // Reset the counter if reset is low (active low reset)
    end else begin
        // Shift the '1' bit to the next position in the cyclic sequence
        if (state == 8'b1000_0000) begin
            state <= 8'b0000_0001; // Wrap around to the LSB when at MSB
        end else begin
            state <= {state[6:0], state[7]}; // Shift the bits to the right
        end
    end
end

// Assign the current state to the output
assign out = state;

endmodule