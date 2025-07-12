module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to hold the output of the flip-flop

// XOR gate implementation
wire xor_out = in ^ out_reg;

// D flip-flop implementation
always @(posedge clk) begin
    out_reg <= xor_out;
end

// Continuous assignment to output port
assign out = out_reg;

endmodule