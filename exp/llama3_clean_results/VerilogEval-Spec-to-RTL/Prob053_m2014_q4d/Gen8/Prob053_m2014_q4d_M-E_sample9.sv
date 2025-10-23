module TopModule(
    input clk,
    input in,
    output reg out = 0 // Initialize out to a known value to avoid undefined behavior
);

// Combined sequential and combinational logic
always @(posedge clk) begin
    out <= in ^ out; // Update out with the result of the XOR operation on the rising edge of the clock
end

endmodule