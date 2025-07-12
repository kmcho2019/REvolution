module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Explicitly initialize out to avoid any potential issues
initial begin
    out = 1'b0;
end

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    out <= in ^ out; // Update out with the computed XOR result at the rising edge of clk
end

endmodule