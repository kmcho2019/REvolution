module TopModule(
    input clk,
    input in,
    output reg out = 0 // Initialize out to 0 to avoid undefined behavior
);

// Directly calculate the XOR result and use it as the input to the D flip-flop
always @(posedge clk) begin
    out <= in ^ out; // Update the output at the positive edge of the clock
end

endmodule