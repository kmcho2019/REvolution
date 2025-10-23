module TopModule(
    input clk,
    input x,
    output z
);

reg qXOR, qAND, qOR;
wire xorOut, andOut, orOut;

assign xorOut = x ^ qXOR;
assign andOut = x & ~qAND;
assign orOut = x | ~qOR;

always @ (posedge clk) begin
    qXOR <= xorOut;
    qAND <= andOut;
    qOR <= orOut;
end

assign z = ~(xorOut | andOut | orOut);

endmodule