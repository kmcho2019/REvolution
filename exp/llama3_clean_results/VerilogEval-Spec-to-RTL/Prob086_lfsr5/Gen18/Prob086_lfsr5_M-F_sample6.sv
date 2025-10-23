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
        // Calculate the new LSB based on the XOR of the taps and the current LSB
        reg new_lsb;
        new_lsb = state[4] ^ state[2] ^ state[0];
        
        // Shift the current state to the right and incorporate the new LSB
        state <= {new_lsb, state[4:1]}; // Shift right and apply feedback
    end
end

assign q = state; // Output the current state of the LFSR

endmodule