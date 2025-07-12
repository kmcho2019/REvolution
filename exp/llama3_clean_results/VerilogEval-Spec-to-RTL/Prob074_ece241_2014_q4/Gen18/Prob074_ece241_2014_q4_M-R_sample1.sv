module TopModule(
    input clk,
    input x,
    output reg z
);

// Individual flip-flops for each gate output
reg q_xor, q_and, q_or;

// Combinational logic for the gates
always @(*) begin
    q_xor <= x ^ q_xor;
    q_and <= x & ~q_and;
    q_or <= x | ~q_or;
end

// Sequential logic to update the flip-flops
always @(posedge clk) begin
    q_xor <= q_xor;
    q_and <= q_and;
    q_or <= q_or;
end

// Combinational logic to compute the output 'z'
assign z = ~(q_xor | q_and | q_or);

endmodule