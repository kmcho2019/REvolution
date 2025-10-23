module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Calculate the feedback signal
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Always block to handle the clock and reset
always @(posedge clk) begin
    // If reset is high, initialize the register to zero
    if (rst) begin
        out <= 4'b0000;
    end else begin
        // Shift the bits left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule