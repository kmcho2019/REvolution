module TopModule (
    input clk,
    input x,
    output z
);

    // 3-bit shift register to store state [xor, and, or]
    reg [2:0] state = 3'b000;
    
    // Next state computation
    wire [2:0] next_state;
    
    // XOR path: x XOR current state[2] (feedback)
    assign next_state[2] = x ^ state[2];
    
    // AND path: x AND (NOT current state[1])
    assign next_state[1] = x & (~state[1]);
    
    // OR path: x OR (NOT current state[0])
    assign next_state[0] = x | (~state[0]);
    
    // Update state on positive clock edge
    always @(posedge clk) begin
        state <= next_state;
    end
    
    // Output is NOR of current state bits
    assign z = ~(|state);
    
endmodule