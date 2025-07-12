module TopModule(
    input clk,
    input x,
    output z
);

reg q_xor, q_and, q_or;

always @(posedge clk) begin
    reg xor_out, and_out, or_out;
    
    // Compute the outputs of the XOR, AND, and OR gates
    xor_out = x ^ q_xor;
    and_out = x & ~q_and;
    or_out = x | ~q_or;
    
    // Update the flip-flop states
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
    
    // Compute the output z of the NOR gate
    z <= ~(xor_out | and_out | or_out);
end

initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
end

endmodule