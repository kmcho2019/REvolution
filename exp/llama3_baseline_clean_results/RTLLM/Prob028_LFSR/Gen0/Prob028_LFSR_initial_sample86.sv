module LFSR(
    input clk,      // Clock signal
    input rst,      // Active high reset signal
    output [3:0] out // 4-bit output representing the current state
);

reg [3:0] state;    // Internal register to hold the current state

// Combinational logic to calculate the feedback
assign out = state;

always @ (posedge clk) begin
    if (rst) begin
        // If reset is high, initialize the register to zero
        state <= 4'b0000;
    end else begin
        // Calculate the feedback by XORing the MSB and the second MSB, then inverting the result
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule