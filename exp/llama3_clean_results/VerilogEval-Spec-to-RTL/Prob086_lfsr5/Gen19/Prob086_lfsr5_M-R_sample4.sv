module TopModule (
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

// Update the state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Reset to a known non-zero state
    end else begin
        reg [4:0] next;
        next[4] = state[0] ^ state[3] ^ state[4];
        next[3:0] = {state[3:1], state[4]};
        state <= next;
    end
end

assign q = state;

endmodule