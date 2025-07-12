module TopModule(
    input clk,
    input x,
    output z
);

reg qXor, qAnd, qOr; // Outputs of the D flip-flops

// Assign initial values to the flip-flop outputs
initial begin
    qXor = 0;
    qAnd = 0;
    qOr = 0;
end

// D flip-flop for XOR gate
always @(posedge clk) begin
    qXor <= x ^ qXor;
end

// D flip-flop for AND gate
always @(posedge clk) begin
    qAnd <= x & ~qAnd;
end

// D flip-flop for OR gate
always @(posedge clk) begin
    qOr <= x | ~qOr;
end

// NOR gate
assign z = ~(qXor | qAnd | qOr);

endmodule