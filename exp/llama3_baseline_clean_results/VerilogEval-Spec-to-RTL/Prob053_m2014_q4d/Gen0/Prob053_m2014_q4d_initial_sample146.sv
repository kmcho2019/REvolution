module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to hold the flip-flop's output
assign out = out_reg; // Continuous assignment to output

// XOR operation between 'in' and the current state of the flip-flop
wire xor_out;
assign xor_out = in ^ out;

// D flip-flop
always @(posedge clk) begin
    out_reg <= xor_out; // Update the flip-flop's state on the positive edge of clk
end

endmodule