module TopModule (
    input clk,
    input in,
    output reg out
);

wire d;

assign d = in ^ out;

always @(posedge clk) begin
    out <= d;
end

endmodule