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
    
    // State transition logic (direct combinational equation)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= (state & in) | (~state & ~in);
    end
    
    // Output logic
    assign out = state;  // state B outputs 1
    
endmodule