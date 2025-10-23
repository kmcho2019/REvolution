module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Calculate the feedback value
wire feedback = ~(out[3] ^ out[2]);

// Handle reset and clock edges
always @(posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero on active high reset
        out <= 4'd0;
    end else begin
        // Shift the bits left and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule