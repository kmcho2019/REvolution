module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // register to hold the output of the D flip-flop

assign out = out_reg; // continuous assignment to output port

// D flip-flop with positive edge trigger and no reset
always @(posedge clk) begin
    out_reg <= in ^ out_reg; // XOR operation with feedback
end

endmodule