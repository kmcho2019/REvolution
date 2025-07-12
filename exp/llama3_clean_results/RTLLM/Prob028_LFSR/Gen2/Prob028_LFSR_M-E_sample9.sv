module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] state;  // 4-bit register to store the current state of the LFSR

// Initialize the state to a predefined non-zero value when reset is high
always @ (posedge clk) begin
    if (rst) begin
        state <= 4'b1001;  // Initialize to a non-zero value
    end else begin
        // Calculate the feedback signal using multiple XOR operations
        reg fb;
        fb = ~(state[3] ^ state[2] ^ state[0]);  // Invert the result of XORing the most significant, second most significant, and least significant bits
        
        // Shift the bits to the left and insert the feedback value at the least significant bit
        state <= {state[2:0], fb};
    end
end

// Assign the state to the output
assign out = state;

endmodule