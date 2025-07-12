module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register states (one-hot-like encoding)
    // Order: A, B, C, D, E, F
    reg [5:0] state;

    // Next state computation (parallel for each state)
    wire [5:0] next_state;
    
    // State A transitions
    assign next_state[0] = (state[0] & w) | (state[3] & w);
    
    // State B transitions
    assign next_state[1] = (state[0] & ~w);
    
    // State C transitions
    assign next_state[2] = (state[1] & ~w) | (state[5] & ~w);
    
    // State D transitions
    assign next_state[3] = (state[1] & w) | (state[2] & w) | 
                          (state[4] & w) | (state[5] & w);
    
    // State E transitions
    assign next_state[4] = (state[2] & ~w) | (state[4] & ~w);
    
    // State F transitions
    assign next_state[5] = (state[3] & ~w);

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001;  // Reset to state A
        else
            state <= next_state;
    end

    // Output is combination of states E and F
    assign z = state[4] | state[5];

endmodule