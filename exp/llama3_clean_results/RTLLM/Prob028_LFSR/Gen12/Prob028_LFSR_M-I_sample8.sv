module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

// LFSR logic with synchronous reset
always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to zero on reset
    end else begin
        // Calculate feedback by XORing MSB and second MSB, and inverting the result
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule