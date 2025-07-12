module TopModule(
    input clk,
    input x,
    output reg z
);

reg q_xor = 1'b0, q_and = 1'b0, q_or = 1'b0; // Initialize flip-flops to zero

// Combinational logic to compute the gate outputs
wire xor_out = x ^ q_xor;
wire and_out = x & ~q_and;
wire or_out = x | ~q_or;

// Sequential logic to update the states
always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

// Directly assign the output 'z' using the outputs of the flip-flops
always @(*) begin
    z = ~(q_xor | q_and | q_or);
end

endmodule