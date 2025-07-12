module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // reg to hold the output of the flip-flop

assign out = out_reg; // assign the output of the flip-flop to the output port

always @ (posedge clk) // positive edge triggered always block
begin
    out_reg <= in ^ out; // capture the XOR of 'in' and 'out' on the positive edge of 'clk'
end

endmodule