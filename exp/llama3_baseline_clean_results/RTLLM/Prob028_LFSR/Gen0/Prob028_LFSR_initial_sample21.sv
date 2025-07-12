module LFSR (
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out   // 4-bit output representing the current state of the LFSR
);

// Calculate the feedback signal by XORing the most significant bit and the second most significant bit, then invert the result
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// On the rising edge of the clock, update the register value
always @(posedge clk) begin
    if (rst) begin
        // If reset is high, initialize the register to zero
        out <= 4'b0000;
    end else begin
        // If reset is low, shift the bits in the register to the left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule