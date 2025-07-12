module TopModule(
    input clk,
    input in,
    output reg out = 0 // Initialize out to a known value to avoid undefined behavior
);

reg xor_out; // Intermediate signal to hold the output of the XOR operation

// Combinational logic (XOR operation)
always @(*) begin
    xor_out = in ^ out; // Calculate the XOR of 'in' and 'out'
end

// Sequential logic (D flip-flop)
always @(posedge clk) begin
    out <= xor_out; // Update 'out' with the result of the XOR operation on the rising edge of the clock
end

endmodule