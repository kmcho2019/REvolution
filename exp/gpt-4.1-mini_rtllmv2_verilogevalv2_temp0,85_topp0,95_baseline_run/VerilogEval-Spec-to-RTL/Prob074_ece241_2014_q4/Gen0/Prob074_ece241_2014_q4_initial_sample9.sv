module TopModule(
    input clk,
    input x,
    output z
);

// Flip-flop outputs
reg q_xor, q_and, q_or;

// D inputs for flip-flops
wire d_xor, d_and, d_or;

// Compute D inputs according to specification
assign d_xor = x ^ q_xor;
assign d_and = x & (~q_and);
assign d_or  = x | (~q_or);

// Sequential logic: positive edge-triggered flip-flops with initial reset to zero
initial begin
    q_xor = 0;
    q_and = 0;
    q_or  = 0;
end

always @(posedge clk) begin
    q_xor <= d_xor;
    q_and <= d_and;
    q_or  <= d_or;
end

// Output z is 3-input NOR of the flip-flop outputs
assign z = ~(q_xor | q_and | q_or);

endmodule