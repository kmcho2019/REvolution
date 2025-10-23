module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

always @(posedge clk) begin
    if (rst) begin
        // Reset the register to zero on rising edge of clock when rst is high
        state <= 4'b0000;
    end else begin
        // Calculate the feedback value by XORing the most significant bit and the second most significant bit
        reg feedback;
        feedback = ~(state[3] ^ state[2]);
        
        // Shift the register left and insert the feedback value at the least significant bit
        state <= {state[2:0], feedback};
    end
end

// Assign the current state of the register to the output
assign out = state;

endmodule