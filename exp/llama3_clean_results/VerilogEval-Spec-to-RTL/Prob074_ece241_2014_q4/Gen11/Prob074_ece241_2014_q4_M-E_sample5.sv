module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_state, and_state, or_state;
reg xor_out, and_out, or_out;

always @(posedge clk) begin
    // Compute the outputs of the gates
    xor_out <= x ^ xor_state;
    and_out <= x & ~and_state;
    or_out <= x | ~or_state;
    
    // Update the states of the flip-flops
    xor_state <= xor_out;
    and_state <= and_out;
    or_state <= or_out;
    
    // Compute the final output 'z'
    z <= ~(xor_state | and_state | or_state);
end

initial begin
    xor_state = 0;
    and_state = 0;
    or_state = 0;
    z = 1;  // Initialize 'z' based on the initial state of the flip-flops
end

endmodule