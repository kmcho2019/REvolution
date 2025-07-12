module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output
);

// Calculate the feedback signal
wire feedback = ~(out[3] ^ out[2]);

// Handle the clock and reset logic
always @ (posedge clk) begin
    if (rst) begin
        // Reset the register to zero
        out <= 4'd0;
    end else begin
        // Shift the bits to the left and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule