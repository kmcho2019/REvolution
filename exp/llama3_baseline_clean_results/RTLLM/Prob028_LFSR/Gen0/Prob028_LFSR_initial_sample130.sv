module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback calculation: XOR of most significant bit and second most significant bit, then invert
assign out[0] = ~(out[3] ^ out[2]);

// Handle clock edge and reset logic
always @(posedge clk) begin
    if (rst) begin
        // If reset is high, initialize the register to zero
        out <= 4'b0000;
    end else begin
        // Otherwise, shift the register left and insert the new feedback value at the LSB
        out <= {out[2:0], out[0]};
    end
end

endmodule