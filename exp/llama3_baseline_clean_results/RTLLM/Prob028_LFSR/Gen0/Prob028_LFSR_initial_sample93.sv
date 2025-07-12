module LFSR (
    input clk,    // Clock signal
    input rst,    // Active high reset signal
    output [3:0] out  // 4-bit output
);

reg [3:0] state;  // Internal register to hold the state

// Feedback calculation: XOR of MSB and second MSB, then invert
assign out = state;

always @ (posedge clk) begin
    if (rst) begin
        // Reset the state to zero when rst is high
        state <= 4'd0;
    end else begin
        // Calculate the feedback signal
        reg fb;
        assign fb = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the feedback at the LSB
        state <= {state[2:0], fb};
    end
end

endmodule