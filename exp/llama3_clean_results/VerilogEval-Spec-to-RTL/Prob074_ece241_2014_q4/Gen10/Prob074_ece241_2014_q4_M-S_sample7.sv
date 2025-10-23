module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_state = 0, and_state = 0, or_state = 0;

always @(posedge clk) begin
    // Update the state of the flip-flops
    xor_state <= x ^ xor_state;
    and_state <= x & ~and_state;
    or_state <= x | ~or_state;
    
    // Compute the final output 'z'
    z <= ~(xor_state | and_state | or_state);
end

endmodule