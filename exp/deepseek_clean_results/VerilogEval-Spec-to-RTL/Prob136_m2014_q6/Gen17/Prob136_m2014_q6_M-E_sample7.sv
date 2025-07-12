module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register states (circular buffer)
    // Order: A, B, C, D, E, F
    reg [5:0] state = 6'b000001;
    
    // Next state logic - circular shift left/right
    wire [5:0] next_state;
    assign next_state = w ? {state[0], state[5:1]} :  // right shift (1)
                        {state[4:0], state[5]};      // left shift (0)
    
    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001;  // Reset to state A
        else
            state <= next_state;
    end
    
    // Output logic - states E (bit4) and F (bit5) output 1
    assign z = state[4] | state[5];
    
    // Optional: Named parameters for readability
    // localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
    
endmodule