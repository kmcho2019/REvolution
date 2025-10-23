module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    
    // Optimized next state logic using boolean equations
    // From K-map: next_state = (state & in) | (~state & ~in)
    wire next_state = (state ^ ~in);
    
    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end
    
    // Output is simply the state bit (B=1, A=0)
    assign out = state;
    
endmodule