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
        // Calculate the new MSB based on the taps (positions 5 and 3) and the current LSB
        reg new_msb;
        new_msb = state[4] ^ state[2] ^ state[0];
        
        // Shift the current state to the right and insert the new MSB
        state <= {new_msb, state[4:1]};
    end
end

assign q = state; // Output the current state of the LFSR

endmodule