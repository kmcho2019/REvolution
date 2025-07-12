module TopModule(
    input clk,
    input in,
    output reg out = 0  // Initialize to 0 to avoid unknown startup state
);

wire d;
assign d = in ^ out;

always @(posedge clk) begin
    out <= d;
end

endmodule