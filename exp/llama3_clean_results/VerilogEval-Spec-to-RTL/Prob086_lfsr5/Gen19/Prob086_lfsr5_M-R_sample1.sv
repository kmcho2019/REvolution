module TopModule (
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        // Reset the LFSR output to a non-zero state (e.g., 1)
        state <= 5'b00001;
    end else begin
        // Calculate the next state
        state <= {state[3] ^ state[0], state[4:1]};
    end
end

assign q = state;

endmodule