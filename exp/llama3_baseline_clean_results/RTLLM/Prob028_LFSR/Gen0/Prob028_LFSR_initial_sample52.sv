module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Calculate the feedback signal by XORing the most significant and second most significant bits
wire feedback = ~(out[3] ^ out[2]);

// Implement the LFSR operation
always @(posedge clk) begin
    if (rst) begin
        // Initialize the register to zero when the reset signal is high
        out <= 4'b0000;
    end else begin
        // Shift the bits to the left and insert the feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule