module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to store the output of the D flip-flop
assign out = out_reg; // Continuously assign the output of the register to the output port

always @(posedge clk) // On the positive edge of the clock
begin
    out_reg <= in ^ out_reg; // The input to the D flip-flop is the XOR of 'in' and the current output
end

endmodule