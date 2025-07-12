module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // Register to store the output of the flip-flop

// Two-input XOR gate
wire xor_out = in ^ out;

// D flip-flop with positive edge trigger and no reset
always @(posedge clk) begin
    out_reg <= xor_out;
end

// Continuous assignment to drive the output
assign out = out_reg;

endmodule