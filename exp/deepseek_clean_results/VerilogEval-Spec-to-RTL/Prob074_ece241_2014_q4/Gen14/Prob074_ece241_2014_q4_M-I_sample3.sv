module TopModule (
    input clk,
    input x,
    output z
);

    // 3-bit register for all states with explicit initialization
    // [0] - XOR path, [1] - AND path, [2] - OR path
    reg [2:0] state = 3'b0;
    
    // Combined state update and next state logic
    always @(posedge clk) begin
        state[0] <= x ^ state[0];    // XOR path
        state[1] <= x & ~state[1];   // AND path with complemented feedback
        state[2] <= x | ~state[2];   // OR path with complemented feedback
    end
    
    // Output is NOR of all state bits
    assign z = ~(|state);

endmodule