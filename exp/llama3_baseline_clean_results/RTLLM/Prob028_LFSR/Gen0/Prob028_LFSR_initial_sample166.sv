module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback calculation
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Main logic
always @(posedge clk) begin
    if (rst) begin
        // Reset the register to zero
        out <= 4'd0;
    end else begin
        // Shift the bits to the left and insert the feedback value
        out <= {out[2:0], feedback};
    end
end

endmodule