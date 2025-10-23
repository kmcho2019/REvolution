module TopModule(
    input clk,
    input in,
    output reg out = 0 // Initialize out to 0
);

reg xor_out; // Intermediate wire for XOR output

// Combinational logic: XOR gate
always @(*) begin
    xor_out = in ^ out;
end

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= xor_out;
end

endmodule