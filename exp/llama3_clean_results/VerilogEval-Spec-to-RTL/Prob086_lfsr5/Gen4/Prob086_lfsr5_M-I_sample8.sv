module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Define the current state of the LFSR
reg [4:0] current_state;

// Combinational logic to compute the next state
always @(*) begin
    // Shift the bits to the right
    q[4] = current_state[3];
    q[3] = current_state[2] ^ current_state[0]; // Tap at position 3
    q[2] = current_state[1];
    q[1] = current_state[0];
    q[0] = current_state[4] ^ current_state[2]; // Tap at position 5
end

// Update the state on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the LFSR output to a non-zero value
        current_state <= 5'b10001; // A valid state in the LFSR sequence
    end else begin
        // Update the state
        current_state <= q;
    end
end

endmodule