module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Reset to 1, the LSB
    end else begin
        // Calculate the new state by XORing the LSB with the tapped bits and shifting
        state <= {state[3], state[2] ^ state[0], state[1], state[0], state[4] ^ state[0]}; 
    end
end

assign q = state; // Output the current state of the LFSR

endmodule