module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // reg to hold the state of the flip-flop
assign out = out_reg; // assign the reg to the output

always @ (posedge clk) // update at the positive edge of the clock
    out_reg <= in ^ out_reg; // XOR the input with the current state and update the state

endmodule