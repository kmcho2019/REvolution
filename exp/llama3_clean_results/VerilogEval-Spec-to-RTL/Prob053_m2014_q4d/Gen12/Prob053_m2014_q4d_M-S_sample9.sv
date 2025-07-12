module TopModule(
    input clk,
    input in,
    output reg out
);

always @(posedge clk) begin
    out <= in ^ out;
end

// Initial value to avoid undefined behavior
initial begin
    out = 1'b0;
end

endmodule