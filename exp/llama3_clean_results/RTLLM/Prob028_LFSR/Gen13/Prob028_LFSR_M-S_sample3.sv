module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0; // Reset to zero
    end else begin
        out <= {out[2:0], ~(out[3] ^ out[2])}; // Shift and apply feedback
    end
end

endmodule