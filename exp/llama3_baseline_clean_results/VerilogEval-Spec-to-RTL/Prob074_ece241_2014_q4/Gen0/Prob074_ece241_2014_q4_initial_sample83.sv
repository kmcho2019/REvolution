module TopModule(
    input clk,
    input x,
    output z
);

reg q_xor, q_and, q_or;

// Instantiate the gates and flip-flops
wire xor_out = x ^ q_xor;
wire and_out = x & ~q_and;
wire or_out = x | ~q_or;

always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

// Connect the flip-flop outputs to a NOR gate to produce the final output
assign z = ~(q_xor | q_and | q_or);

endmodule