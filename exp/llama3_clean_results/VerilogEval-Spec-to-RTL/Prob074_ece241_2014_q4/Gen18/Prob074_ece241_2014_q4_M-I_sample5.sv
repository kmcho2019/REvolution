module TopModule(
    input clk,
    input x,
    output reg z
);

// Individual flip-flops for each state, with initial values set to 0
reg q_xor = 1'b0;
reg q_and = 1'b0;
reg q_or = 1'b0;

// Compute complemented values for AND and OR gates
wire q_and_c = ~q_and;
wire q_or_c = ~q_or;

// Combinational logic to compute the gate outputs
reg xor_out, and_out, or_out;

always @(*) begin
    xor_out = x ^ q_xor;
    and_out = x & q_and_c;
    or_out = x | q_or_c;
end

// Sequential logic to update the states
always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

// Output logic
always @(*) begin
    z = ~(q_xor | q_and | q_or);
end

endmodule