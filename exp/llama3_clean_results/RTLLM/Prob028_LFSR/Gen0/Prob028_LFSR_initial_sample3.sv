module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] state;  // Internal register to hold the current state of the LFSR

always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize the register to zero
        state <= 4'b0;
    end else begin
        // Calculate the feedback signal
        reg fb;
        fb = ~(state[3] ^ state[2]);  // Invert the result of XORing the most significant and the second most significant bits
        
        // Shift the bits to the left and insert the feedback value at the least significant bit
        state <= {state[2:0], fb};
    end
end

assign out = state;  // Assign the current state to the output

endmodule