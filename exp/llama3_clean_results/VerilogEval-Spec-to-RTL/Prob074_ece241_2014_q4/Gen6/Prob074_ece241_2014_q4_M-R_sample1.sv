module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;

// XOR gate
assign xor_out = x ^ state_xor;
// AND gate
assign and_out = x & ~state_and;
// OR gate
assign or_out = x | ~state_or;

// D flip-flops
reg state_xor, state_and, state_or;
always @(posedge clk) begin
    state_xor <= xor_out;
    state_and <= and_out;
    state_or <= or_out;
end

// Three-input NOR gate
assign z = ~(xor_out | and_out | or_out);

initial begin
    state_xor = 1'b0;
    state_and = 1'b0;
    state_or = 1'b0;
end

endmodule