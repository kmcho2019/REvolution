module TopModule(
    input clk,
    input in,
    output reg out
);

wire xor_out; // Intermediate wire to hold the output of the XOR gate
assign xor_out = in ^ out; // Describe the combinational logic of the XOR gate

always @(posedge clk) begin
    out <= xor_out; // Update the output of the flip-flop on the positive edge of the clock
end

endmodule