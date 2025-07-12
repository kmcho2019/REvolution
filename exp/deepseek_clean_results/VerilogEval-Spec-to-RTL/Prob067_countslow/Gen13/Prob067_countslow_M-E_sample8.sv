module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [9:0] state;  // One-hot state (bit 0 = 0, bit 1 = 1, ..., bit 9 = 9)

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // Reset to state 0
    end
    else if (slowena) begin
        if (state[9]) begin      // Terminal state (9)
            state <= 10'b0000000001;  // Wrap to 0
        end
        else begin
            state <= state << 1;  // Shift to next state
        end
    end
end

// Output is the binary representation of the one-hot state
assign q = {state[8]|state[9],  // Bit 3 (8 and 9 have MSB set)
            state[4]|state[5]|state[6]|state[7]|state[8]|state[9],  // Bit 2
            state[2]|state[3]|state[6]|state[7]|state[8]|state[9],  // Bit 1
            state[1]|state[3]|state[5]|state[7]|state[9]};  // Bit 0

endmodule