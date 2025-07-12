module TopModule(
    input clk,
    input in,
    output reg out
);

// Single always block for both combinational and sequential logic
always @(posedge clk or in) begin
    out <= in ^ out;
end

endmodule