module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinational logic to compute the XOR result
always @(posedge clk) begin
    // Update out with the computed XOR result
    out <= in ^ out;
end

endmodule