module TopModule(
    input clk,
    input x,
    output z
);

reg q0, q1, q2; // Outputs of the D flip-flops
reg xor_out, and_out, or_out; // Outputs of the XOR, AND, and OR gates

// Define the outputs of the gates based on the flip-flop outputs and input x
always @(*) begin
    xor_out = x ^ q0;
    and_out = x & (~q1);
    or_out = x | (~q2);
end

// Update the flip-flop outputs on the positive edge of the clock
always @(posedge clk) begin
    q0 <= xor_out;
    q1 <= and_out;
    q2 <= or_out;
end

// The final output Z is the output of the NOR gate
assign z = ~(q0 | q1 | q2);

initial begin
    q0 = 0;
    q1 = 0;
    q2 = 0;
end

endmodule