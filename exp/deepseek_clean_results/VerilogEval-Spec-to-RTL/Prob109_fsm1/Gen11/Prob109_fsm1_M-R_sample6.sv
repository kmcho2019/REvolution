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
    
    // Combined state transition and register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= (state ^ ~in); // Equivalent to state XOR NOT input
    end
    
    // Output logic remains simple
    assign out = state;
    
endmodule