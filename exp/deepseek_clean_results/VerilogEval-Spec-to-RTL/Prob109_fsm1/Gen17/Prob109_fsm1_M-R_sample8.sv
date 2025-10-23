module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State is stored in a single flip-flop
    reg state = 1'b1; // Default to state B
    
    // Next state logic (simplified boolean expressions)
    wire next_state = areset ? 1'b1 : 
                    (~state & ~in) | (state & in);
    
    // State update
    always @(posedge clk or posedge areset) begin
        state <= next_state;
    end
    
    // Output is simply the state (since B=1, A=0)
    assign out = state;
    
endmodule