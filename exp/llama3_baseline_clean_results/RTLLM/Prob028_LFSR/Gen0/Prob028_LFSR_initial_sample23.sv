module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero when the reset signal is high
        out <= 4'b0;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
        reg [3:0] temp_out;
        temp_out = out;
        
        // Shift the bits in the register to the left
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule