module TopModule(
    input clk,
    input x,
    output reg z
);

reg [2:0] state;

initial begin
    state = 0;
end

always @(posedge clk) begin
    // Update state directly
    state[0] <= x ^ state[0];
    state[1] <= x & ~state[1];
    state[2] <= x | ~state[2];
    
    // Compute z after state has been updated in the same clock cycle
    // However, since we are using non-blocking assignments for state,
    // we should compute z based on the current state values, not the next state values.
    // Thus, we compute z based on the current state before it's updated.
    z <= ~(x ^ state[0] | x & ~state[1] | x | ~state[2]);
end

endmodule