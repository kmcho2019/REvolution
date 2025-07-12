module TopModule (
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

// Update the state of the LFSR
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b10000; // Reset to a known non-zero state
    end else begin
        state <= {state[0] ^ state[2], state[4:1]};
    end
end

assign q = state;

endmodule