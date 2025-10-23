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
    
    // State register update with direct next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= (state == A) ? in : (state | in);
    end
    
    // Output logic
    assign out = state;
    
endmodule