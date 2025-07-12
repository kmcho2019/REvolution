module TopModule(
    input clk,
    input x,
    output reg z
);

// Individual flip-flops for each state, with initial values set to 0
reg q_xor = 1'b0;
reg q_and = 1'b0;
reg q_or = 1'b0;

// Sequential logic to update the states
always @(posedge clk) begin
    q_xor <= x ^ q_xor;
    q_and <= x & ~q_and;
    q_or <= x | ~q_or;
end

// Combinational logic to compute the output z
assign z = ~(q_xor | q_and | q_or);

endmodule