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
    reg [4:0] next_state;
    next_state[4] = current_state[3] ^ current_state[0]; // Tap at position 5
    next_state[3] = current_state[2] ^ current_state[0]; // Tap at position 3
    next_state[2] = current_state[1];
    next_state[1] = current_state[0];
    next_state[0] = current_state[4]; // Least significant bit is simply the previous most significant bit in a shift register
    q = next_state;
end

// Update the state on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the LFSR output to a non-zero value
        current_state <= 5'b10000; // A valid state in the LFSR sequence
    end else begin
        // Update the state
        current_state <= q;
    end
end

endmodule