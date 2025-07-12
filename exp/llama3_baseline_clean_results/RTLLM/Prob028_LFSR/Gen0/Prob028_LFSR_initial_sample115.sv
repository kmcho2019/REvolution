module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

always @(posedge clk) begin
    if (rst) begin
        // Initialize the register to zero on reset
        state <= 4'b0000;
    end else begin
        // Calculate the feedback by XORing the most significant bit and the second most significant bit
        reg feedback;
        feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits in the register to the left and insert the feedback value at the least significant bit
        state <= {state[2:0], feedback};
    end
end

// Assign the output to the current state of the LFSR
assign out = state;

endmodule