module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] state;  // Internal register to hold the current state

// Feedback calculation: XOR of MSB and second MSB, then invert
assign out = state;
always @(posedge clk) begin
    if (rst) begin  // If reset is high, initialize the state to zero
        state <= 4'd0;
    end else begin
        // Calculate the new feedback value
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits to the left and insert the feedback at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule