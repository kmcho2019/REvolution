module TopModule(
    input clk,
    input x,
    output z
);

reg state_xor, state_and, state_or;
reg prev_xor, prev_and, prev_or;

// Initialize state variables
initial begin
    state_xor = 1'b0;
    state_and = 1'b0;
    state_or = 1'b0;
    prev_xor = 1'b0;
    prev_and = 1'b0;
    prev_or = 1'b0;
end

// XOR gate
wire xor_out;
assign xor_out = x ^ prev_xor;

// AND gate
wire and_out;
assign and_out = x & ~prev_and;

// OR gate
wire or_out;
assign or_out = x | ~prev_or;

// Update previous state variables
always @(posedge clk) begin
    prev_xor <= xor_out;
    prev_and <= and_out;
    prev_or <= or_out;
    state_xor <= xor_out;
    state_and <= and_out;
    state_or <= or_out;
end

// Three-input NOR gate
assign z = ~(xor_out | and_out | or_out);

endmodule