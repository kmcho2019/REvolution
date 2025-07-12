module TopModule (
    input clk,
    input x,
    output z
);

    // 3-bit register for all states
    reg [2:0] state;

    // Initialize all flip-flops to zero at power-up
    initial begin
        state = 3'b0;
    end

    // Sequential logic for state updates
    always @(posedge clk) begin
        // XOR path: x XOR previous state
        state[0] <= x ^ state[0];
        
        // AND path: x AND complement of previous state
        state[1] <= x & (~state[1]);
        
        // OR path: x OR complement of previous state
        state[2] <= x | (~state[2]);
    end

    // Output is NOR of all state bits
    assign z = ~(|state);

endmodule