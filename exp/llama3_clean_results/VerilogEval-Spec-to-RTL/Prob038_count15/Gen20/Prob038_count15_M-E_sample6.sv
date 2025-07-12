module TopModule (
    input clk,
    input reset,
    output reg [3:0] q = 0
);

reg [3:0] lfsr_state = 0;

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        lfsr_state <= 4'd0;
    end else begin
        // LFSR update logic
        // For a 4-bit LFSR with polynomial x^4 + x + 1, the update equation is:
        // lfsr_state[3] = lfsr_state[0] ^ lfsr_state[2]
        // and the state is shifted left
        lfsr_state <= {lfsr_state[0] ^ lfsr_state[2], lfsr_state[3:1]};
    end
end

assign q = lfsr_state;

endmodule