module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Improved feedback calculation and initialization logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the LFSR to a non-zero initial state for better randomness
        out <= 4'b1000;
    end else begin
        // Simplify the feedback calculation for better area efficiency
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule