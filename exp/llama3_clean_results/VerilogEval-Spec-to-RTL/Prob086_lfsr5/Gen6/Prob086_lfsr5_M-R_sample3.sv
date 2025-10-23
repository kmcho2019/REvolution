module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Calculate the next state of the LFSR using combinational logic
wire next_state = {state[3:0], state[4] ^ state[2]}; // Corrected tap positions

// Update the state at each clock cycle
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Reset the LFSR output to 1
    end else begin
        state <= next_state; // Update the state
    end
end

assign q = state; // Output the current state of the LFSR

endmodule