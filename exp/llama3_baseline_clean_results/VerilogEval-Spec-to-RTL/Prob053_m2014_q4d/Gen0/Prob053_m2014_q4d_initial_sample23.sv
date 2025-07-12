module TopModule(
    input clk,
    input in,
    output reg out
);

// Instantiate an XOR gate with 'in' and 'out' as inputs
wire xor_out;
assign xor_out = in ^ out;

// Instantiate a D flip-flop with 'xor_out' as input and 'clk' as clock
always @(posedge clk) begin
    out <= xor_out;
end

endmodule