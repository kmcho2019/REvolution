module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // register to hold the output of the flip-flop

// D flip-flop
always @(posedge clk) begin
    out_reg <= in ^ out_reg; // XOR operation and assignment to the register
end

// assign the output of the register to the output port
assign out = out_reg;

endmodule