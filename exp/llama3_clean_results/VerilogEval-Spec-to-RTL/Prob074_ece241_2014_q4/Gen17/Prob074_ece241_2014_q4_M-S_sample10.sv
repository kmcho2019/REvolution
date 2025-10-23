module TopModule(
    input clk,
    input x,
    output reg z
);

// Individual flip-flops for each gate output
reg q_xor, q_and, q_or;

// Combinational logic for the gates
wire xor_out = x ^ q_xor;
wire and_out = x & ~q_and;
wire or_out = x | ~q_or;

// Sequential logic to update the flip-flops
always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

// Combinational logic to compute the output 'z'
assign z = ~(q_xor | q_and | q_or);

endmodule