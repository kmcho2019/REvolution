module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize the register to zero on reset
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
        // and then invert the result
        reg [3:0] next_out;
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits in the register left and insert the new feedback value at the least significant bit
        next_out = {out[2:0], feedback};
        
        out <= next_out;
    end
end

endmodule