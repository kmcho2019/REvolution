module TopModule(
    input clk,
    input x,
    output z
);

reg q_xor, q_and, q_or;  // outputs of the D flip-flops

// Calculate the outputs of the gates
wire xor_out = x ^ q_xor;
wire and_out = x & (~q_and);
wire or_out = x | (~q_or);

// Assign the outputs of the gates to the D inputs of the flip-flops
always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

// Calculate the output z using a NOR gate
assign z = ~(q_xor | q_and | q_or);

initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
end

endmodule