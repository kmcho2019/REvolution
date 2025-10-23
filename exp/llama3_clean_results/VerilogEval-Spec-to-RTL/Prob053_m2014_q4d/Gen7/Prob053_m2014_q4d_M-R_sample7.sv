module TopModule(
    input clk,
    input in,
    output reg out
);

wire xor_out; // Temporary wire to hold the output of the XOR gate

assign xor_out = in ^ out; // Describe the combinational logic using assign

always @(posedge clk) begin
    out <= xor_out; // Update the output of the flip-flop on the positive edge of the clock
end

endmodule