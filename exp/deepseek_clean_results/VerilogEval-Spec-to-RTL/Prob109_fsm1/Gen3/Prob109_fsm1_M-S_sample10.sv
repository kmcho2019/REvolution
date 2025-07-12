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
        else if (state == A)
            state <= in ? A : B;
        else // state == B
            state <= in ? B : A;
    end
    
    // Output logic remains simple
    assign out = (state == B);
    
endmodule