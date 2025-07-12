module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Sequential logic for shifting and initialization
always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0; // Initialize register to zero on reset
    end else begin
        // Directly calculate and insert the new feedback value
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule