module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_state, and_state, or_state;

// Sequential logic for updating the state of the flip-flops
always @(posedge clk) begin
    xor_state <= x ^ xor_state;
    and_state <= x & ~and_state;
    or_state <= x | ~or_state;
end

// Combinational logic for the final output 'z'
assign z = ~(xor_state | and_state | or_state);

// Initialize the flip-flops to zero
initial begin
    xor_state = 0;
    and_state = 0;
    or_state = 0;
end

endmodule