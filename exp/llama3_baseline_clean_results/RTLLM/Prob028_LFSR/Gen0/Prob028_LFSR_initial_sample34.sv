module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize the register to zero
        out <= 4'b0000;
    end else begin  // Otherwise, perform the shifting operation
        // Calculate the feedback: XOR of the most significant bit and the second most significant bit, then invert
        reg fb;
        fb = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the feedback at the LSB
        out <= {out[2:0], fb};
    end
end

endmodule