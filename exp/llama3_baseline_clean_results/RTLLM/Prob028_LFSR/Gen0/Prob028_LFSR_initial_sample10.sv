module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] state;  // Internal 4-bit register
assign out = state;  // Assign the internal state to the output

always @ (posedge clk) begin
    if (rst) begin  // Active high reset
        state <= 4'b0;  // Initialize the register to zero
    end else begin
        // Calculate the feedback by XORing the MSB and the second MSB, then inverting the result
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule