module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg prev_xor, prev_and, prev_or;

// Implement D flip-flops with initial reset to zero
initial begin
    prev_xor = 0;
    prev_and = 0;
    prev_or = 0;
end

always @(posedge clk) begin
    // Update D flip-flop outputs
    prev_xor <= xor_out;
    prev_and <= and_out;
    prev_or <= or_out;
end

// XOR gate with input x and flip-flop output
assign xor_out = x ^ prev_xor;

// AND gate with input x and flip-flop's complemented output
assign and_out = x & ~prev_and;

// OR gate with input x and flip-flop's complemented output
assign or_out = x | ~prev_or;

// NOR gate with the outputs of the D flip-flops
assign z = ~(prev_xor | prev_and | prev_or);

endmodule