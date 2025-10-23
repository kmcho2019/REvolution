module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    out <= in ^ out; // Update out with the computed XOR result at the rising edge of clk
end

endmodule