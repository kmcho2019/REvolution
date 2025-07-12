module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_state = 0, and_state = 0, or_state = 0;

always @(posedge clk) begin
    // Store the current states before they are updated
    reg prev_xor_state = xor_state;
    reg prev_and_state = and_state;
    reg prev_or_state = or_state;

    // Compute the outputs of the gates using the current states
    xor_state <= x ^ prev_xor_state;
    and_state <= x & ~prev_and_state;
    or_state <= x | ~prev_or_state;
end

// Compute the final output 'z' using the current state values
assign z = ~(xor_state | and_state | or_state);

endmodule