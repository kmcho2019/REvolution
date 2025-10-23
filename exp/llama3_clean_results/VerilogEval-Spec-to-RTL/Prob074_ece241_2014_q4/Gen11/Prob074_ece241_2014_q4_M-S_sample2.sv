module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_state, and_state, or_state;

always @(posedge clk) begin
    // Update the state of the flip-flops
    xor_state <= x ^ xor_state;
    and_state <= x & ~and_state;
    or_state <= x | ~or_state;
    
    // Compute the final output 'z' after updating the flip-flop states
    z <= ~(xor_state | and_state | or_state);
end

initial begin
    xor_state = 0;
    and_state = 0;
    or_state = 0;
    z = 1; 
end

endmodule