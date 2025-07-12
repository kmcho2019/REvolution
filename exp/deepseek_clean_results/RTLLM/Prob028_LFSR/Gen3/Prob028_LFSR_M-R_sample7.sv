module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback = ~(out[3] ^ out[2]);  // XNOR feedback calculation

always @(posedge clk) begin
    out <= rst ? 4'b0 : {out[2:0], feedback};  // Reset or shift with feedback
end

endmodule