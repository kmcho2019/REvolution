module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] state;  // Internal register to hold the state of the LFSR
assign out = state;  // Assign the internal state to the output

always @ (posedge clk or posedge rst) begin
    if (rst) begin  // If reset is high, initialize the register to zero
        state <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB, then inverting the result
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits to the left and insert the feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule