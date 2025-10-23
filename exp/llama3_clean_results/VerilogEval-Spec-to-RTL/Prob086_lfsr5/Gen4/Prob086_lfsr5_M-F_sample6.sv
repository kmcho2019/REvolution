module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Define the current state of the LFSR
reg [4:0] current_state;

// Define the next state of the LFSR
reg [4:0] next_state;

// Combinational logic to compute the next state
always @(*) begin
    // Shift the bits to the right
    next_state[4] = current_state[3] ^ current_state[0]; // Tap at position 5
    next_state[3] = current_state[2];
    next_state[2] = current_state[1];
    next_state[1] = current_state[0];
    next_state[0] = current_state[4] ^ current_state[0]; // Tap at position 3 was at the 3rd most significant bit, the 3rd bit from the MSB
end

// Update the state on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the LFSR output to a non-zero value
        current_state <= 5'b10001; // A valid state in the LFSR sequence
    end else begin
        // Update the state
        current_state <= next_state;
    end
end

// Assign the current state to the output
assign q = current_state;

endmodule