module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Initialize the state to a value that results in q being 1
initial state = 5'b10000;

// Update the state register
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Reset the state to a value that results in q being 1
    end else begin
        state <= {state[3] ^ state[0], state[2] ^ state[0], state[1], state[0], state[4]}; // Update the state based on the Galois LFSR logic
    end
end

assign q = state; // Output the current state of the LFSR

endmodule