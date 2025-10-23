module LFSR (
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] state;  // 4-bit register to store the current state of the LFSR

// Calculate the feedback signal by XORing the most significant bit and the second most significant bit
assign out = state;

// Always block to handle the clock and reset signals
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // If reset is high, initialize the register to zero
        state <= 4'b0;
    end else begin
        // Calculate the feedback signal
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule