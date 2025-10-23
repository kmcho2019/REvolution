module TopModule (
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

initial state = 5'b10000; // Reset to a known non-zero state

// Update the state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Reset to a known non-zero state
    end else begin
        state[4] <= state[0] ^ state[3];
        state[3:0] <= {state[2:0], state[4]};
    end
end

assign q = state;

endmodule