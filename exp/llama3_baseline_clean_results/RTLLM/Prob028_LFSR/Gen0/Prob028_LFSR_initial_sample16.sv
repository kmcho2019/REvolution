module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output
);

reg [3:0] state;  // 4-bit register to store the current state

// Initialize the output
assign out = state;

// Always block to handle the clock and reset
always @(posedge clk) begin
    if (rst) begin  // Check for active high reset
        state <= 4'b0000;  // Initialize the register to zero
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB, then inverting the result
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits in the register to the left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule