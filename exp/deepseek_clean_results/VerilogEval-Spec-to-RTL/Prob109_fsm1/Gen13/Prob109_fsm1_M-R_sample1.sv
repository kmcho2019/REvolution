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
    
    // State register with direct next state computation
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= (state == A) ? in : ~in;
    end
    
    // Output remains simple state comparison
    assign out = (state == B);
    
endmodule