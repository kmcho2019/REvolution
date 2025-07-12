module TopModule(
    input clk,
    input in,
    output reg out = 0 // Initialize out to a known value to avoid undefined behavior
);

// Combinational logic for XOR operation
wire xor_result;
assign xor_result = in ^ out;

// Sequential logic for D flip-flop
always @(posedge clk) begin
    out <= xor_result; // Update out with the result of the XOR operation on the rising edge of the clock
end

endmodule