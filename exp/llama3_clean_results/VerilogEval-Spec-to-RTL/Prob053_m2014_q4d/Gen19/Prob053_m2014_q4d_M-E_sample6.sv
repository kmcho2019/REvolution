module TopModule(
    input clk,
    input in,
    output reg out
);

reg xor_out; // Intermediate signal for XOR output

// Combinational logic: XOR gate
always @(*) begin
    xor_out = in ^ out; // XOR of in and out
end

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= xor_out; // Capture xor_out on positive edge of clk
end

endmodule