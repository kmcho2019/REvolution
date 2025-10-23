module LFSR (
    input  clk,
    input  rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;          // Initialize to zero as specified
    end else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};  // Shift and insert inverted XOR feedback
    end
end

endmodule