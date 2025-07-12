module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Calculate the feedback signal by XORing out[3] and out[2] and then inverting
wire feedback = ~(out[3] ^ out[2]);

// Sequential logic to update the register on the rising edge of the clock
always @(posedge clk) begin
    if (rst) begin
        // Initialize the register to zero if rst is high
        out <= 4'b0000;
    end else begin
        // Shift the register left and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule