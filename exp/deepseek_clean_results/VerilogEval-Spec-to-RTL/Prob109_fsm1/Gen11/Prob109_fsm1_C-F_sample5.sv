module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions with clear names
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    
    // Simplified next state logic: state XOR (state NOR in)
    // Matches the state transition table with minimal logic
    wire next_state = areset ? B : (state ^ (~state & ~in));
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end
    
    // Output is simply the state bit (since B=1, A=0)
    assign out = state;
    
endmodule