module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_out, and_out, or_out;
reg xor_state, and_state, or_state;

always @(posedge clk) begin
    // Compute the outputs of the gates
    xor_out = x ^ xor_state;
    and_out = x & ~and_state;
    or_out = x | ~or_state;
    
    // Update the state of the flip-flops
    xor_state <= xor_out;
    and_state <= and_out;
    or_state <= or_out;
end

// Compute the final output 'z'
assign z = ~(xor_out | and_out | or_out);

initial begin
    xor_state = 0;
    and_state = 0;
    or_state = 0;
end

endmodule