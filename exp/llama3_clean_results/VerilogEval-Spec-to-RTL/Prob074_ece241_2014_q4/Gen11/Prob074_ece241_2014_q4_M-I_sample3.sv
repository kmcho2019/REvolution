module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_state, and_state, or_state;

always @(posedge clk) begin
    // Compute the outputs of the gates
    reg xor_out, and_out, or_out;
    xor_out = x ^ xor_state;
    and_out = x & ~and_state;
    or_out = x | ~or_state;
    
    // Update the state of the flip-flops using non-blocking assignments
    xor_state <= xor_out;
    and_state <= and_out;
    or_state <= or_out;
    
    // Compute the final output 'z'
    z <= ~(xor_out | and_out | or_out);
end

initial begin
    xor_state = 0;
    and_state = 0;
    or_state = 0;
    // Initialize z to the correct initial value based on the problem's requirements
    // Since all flip-flops are initially reset to zero, the initial value of z should be ~(0 | 0 | 0) = 1
    z = 1;
end

endmodule