module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions (B=1, A=0 matches output requirements)
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    
    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            // Simplified next state logic
            state <= (state == A) ? (in ? A : B) : 
                     (in ? B : A);
    end
    
    // Optimized output - directly use state bit
    assign out = state;
    
endmodule