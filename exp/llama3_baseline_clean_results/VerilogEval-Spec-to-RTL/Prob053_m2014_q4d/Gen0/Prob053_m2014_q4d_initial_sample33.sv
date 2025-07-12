module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to hold the output of the flip-flop
assign out = out_reg; // Continuous assignment to drive the output

// XOR operation
wire xor_out;
assign xor_out = in ^ out;

// D flip-flop with positive edge trigger
always @(posedge clk) begin
    out_reg <= xor_out;
end

endmodule