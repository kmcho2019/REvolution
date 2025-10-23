module TopModule(
    input clk,
    input x,
    output z
);

reg qXOR, qAND, qOR;

assign xXOR = x ^ qXOR;
assign xAND = x & ~qAND;
assign xOR = x | ~qOR;

always @(posedge clk) begin
    qXOR <= xXOR;
    qAND <= xAND;
    qOR <= xOR;
end

assign z = ~(qXOR | qAND | qOR);

endmodule