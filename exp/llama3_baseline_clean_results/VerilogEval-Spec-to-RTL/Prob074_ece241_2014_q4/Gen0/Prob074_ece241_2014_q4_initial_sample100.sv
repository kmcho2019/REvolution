module TopModule(
    input clk,
    input x,
    output z
);

reg qXOR, qAND, qOR; // Outputs of the D flip-flops

// Combinational logic
wire xor_in = x ^ qXOR;
wire and_in = x & ~qAND;
wire or_in = x | ~qOR;

// D flip-flops
always @(posedge clk) begin
    qXOR <= xor_in;
    qAND <= and_in;
    qOR <= or_in;
end

// NOR gate
assign z = ~(qXOR | qAND | qOR);

endmodule