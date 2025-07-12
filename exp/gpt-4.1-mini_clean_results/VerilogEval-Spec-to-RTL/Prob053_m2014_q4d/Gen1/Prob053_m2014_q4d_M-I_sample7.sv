module TopModule (
    input  clk,
    input  in,
    output reg out
);

// Initialize output to zero to avoid unknown simulation state
initial begin
    out = 1'b0;
end

always @(posedge clk) begin
    out <= in ^ out;
end

endmodule