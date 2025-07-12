module TopModule (
    input clk,
    input x,
    output z
);

    // 3-bit register for all states:
    // [0] - XOR path, [1] - AND path, [2] - OR path
    reg [2:0] state = 3'b0;
    
    // Next state logic
    wire [2:0] next_state;
    assign next_state[0] = x ^ state[0];          // XOR path
    assign next_state[1] = x & ~state[1];         // AND path
    assign next_state[2] = x | ~state[2];         // OR path
    
    // State update with synchronous reset
    always @(posedge clk) begin
        state <= next_state;
    end
    
    // Output is NOR of all state bits
    assign z = ~(|state);

endmodule