module TopModule (
    input clk,
    input reset,
    output [4:0] q
);

// Define the LUT for the next state of the LFSR
reg [4:0] state;
reg [4:0] nextState [2**5 - 1:0];

// Initialize the LUT with the next states
initial begin
    for (int i = 0; i < 2**5 - 1; i++) begin
        reg [4:0] currState = i;
        reg [4:0] next;
        // Calculate the next state based on the Galois configuration
        next[4] = currState[0] ^ currState[4] ^ currState[2];
        next[3:0] = currState[4:1];
        nextState[i] = next;
    end
end

// Update the state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Reset to a known non-zero state
    end else begin
        state <= nextState[state];
    end
end

assign q = state;

endmodule