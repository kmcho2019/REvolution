module TopModule(
    input clk,
    input in,
    output reg out
);

// Single always block to handle both combinational and sequential logic
always @(posedge clk) begin
    out <= in ^ out; // Update out with the result of XOR operation
end

endmodule