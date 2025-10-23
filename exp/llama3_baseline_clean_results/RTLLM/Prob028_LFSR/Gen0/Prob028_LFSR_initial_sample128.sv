module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize the register
        out <= 4'b0000;
    end else begin
        // Calculate the feedback by XORing the most significant bit and the second most significant bit, and then invert the result
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the new feedback value at the least significant bit
        out <= {out[2:0], feedback};
    end
end

endmodule