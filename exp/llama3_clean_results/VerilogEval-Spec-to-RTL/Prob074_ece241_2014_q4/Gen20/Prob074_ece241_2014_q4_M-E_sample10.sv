module TopModule(
    input clk,
    input x,
    output reg z
);

// Individual flip-flops for each state, with initial values set to 0
reg q_xor = 1'b0;
reg q_and = 1'b0;
reg q_or = 1'b0;

// Regs to hold the outputs of the gates for pipelining
reg gate_xor_out;
reg gate_and_out;
reg gate_or_out;

// Sequential logic to update the states and compute the gate outputs
always @(posedge clk) begin
    // Compute the outputs of the gates
    gate_xor_out <= x ^ q_xor;
    gate_and_out <= x & ~q_and;
    gate_or_out <= x | ~q_or;
    
    // Update the states
    q_xor <= gate_xor_out;
    q_and <= gate_and_out;
    q_or <= gate_or_out;
end

// Combinational logic to compute the output z based on the updated states
always @(*) begin
    // Compute the output z based on the current states (which are the previous states in the pipeline)
    z = ~(q_xor | q_and | q_or);
end

endmodule