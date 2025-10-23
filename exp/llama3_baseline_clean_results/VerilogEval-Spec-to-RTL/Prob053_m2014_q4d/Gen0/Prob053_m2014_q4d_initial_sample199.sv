module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to hold the output of the flip-flop

// XOR operation
wire xor_out = in ^ out_reg;

// Positive edge triggered D flip-flop without reset
always @(posedge clk) begin
    out_reg <= xor_out;
end

assign out = out_reg;

endmodule