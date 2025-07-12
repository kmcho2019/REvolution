module LFSR(
    input clk, rst,
    output [3:0] out
);

reg [3:0] state;

always @(posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero when rst is high
        state <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
        // and then inverting the result
        reg fb;
        assign fb = ~(state[3] ^ state[2]);
        
        // Shift the register to the left and insert the new feedback value at the LSB
        state <= {state[2:0], fb};
    end
end

// Assign the current state of the LFSR to the output
assign out = state;

endmodule