module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] state;

// Initialize state with a non-zero value
initial begin
    state = 5'b10000;
end

// Update state on positive clock edge
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b10000;  // Reset to a non-zero state
    end else begin
        // Calculate next state by XORing tap bits with LSB and shifting
        state <= {state[3] ^ state[0], state[4:1]};
    end
end

// Assign output to current state
assign q = state;

endmodule