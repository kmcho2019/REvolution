module TopModule(
    input clk,
    input in,
    output reg out
);

always @(posedge clk or in) begin
    if (posedge clk) begin
        out <= in ^ out;
    end
end

endmodule