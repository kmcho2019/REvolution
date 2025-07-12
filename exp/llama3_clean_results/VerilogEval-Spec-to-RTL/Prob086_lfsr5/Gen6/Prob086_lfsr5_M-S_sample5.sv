module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;
assign q = state;

always @ (posedge clk) begin
    if (reset) begin
        state <= 1; // Reset state to 1 (LSB) when reset is high
    end else begin
        state <= ({state[4] ^ state[2] ^ state[0], state[4:1]}); // Corrected LFSR next state calculation
    end
end

initial begin
    state = 1; // Initialize state with a known value
end

endmodule