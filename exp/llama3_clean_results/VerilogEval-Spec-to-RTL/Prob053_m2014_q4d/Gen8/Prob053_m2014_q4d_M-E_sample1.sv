module TopModule(
    input clk,
    input in,
    output reg out = 0 // Initialize out to 0
);

// Use a single always block to implement the XOR and D flip-flop
always @(posedge clk) begin
    out <= in ^ out;
end

endmodule