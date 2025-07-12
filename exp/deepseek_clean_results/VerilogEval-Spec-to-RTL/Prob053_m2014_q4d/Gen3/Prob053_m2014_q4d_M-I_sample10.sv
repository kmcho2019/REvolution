module TopModule (
    input clk,
    input in,
    output reg out
);

wire d;
assign d = in ^ out;

initial out = 1'b0;  // Explicit initialization for simulation

always @(posedge clk) begin
    out <= d;
end

endmodule