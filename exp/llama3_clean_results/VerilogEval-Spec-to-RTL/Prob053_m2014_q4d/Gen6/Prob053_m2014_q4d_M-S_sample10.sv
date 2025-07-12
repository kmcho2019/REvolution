module TopModule(
    input clk,
    input in,
    output reg out
);

initial begin
    out = 1'b0; // Initialize 'out' to 0
end

always @(posedge clk) begin
    out <= in ^ out; // Update 'out' with the XOR of 'in' and the current 'out'
end

endmodule