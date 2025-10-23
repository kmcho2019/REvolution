module TopModule(
    input clk,
    input in,
    output reg out
);

reg xor_out;

// Continuous assignment for XOR gate
assign xor_out = in ^ out;

// D flip-flop implementation
always @ (posedge clk) begin
    out <= xor_out;
end

endmodule