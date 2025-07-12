module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state; // 0=A, 1=B
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // Reset to B
        else if (state)    // Current state B
            state <= in;   // 1->B, 0->A
        else              // Current state A
            state <= ~in; // 1->A, 0->B
    end
    
    assign out = state; // Output is just the state bit
    
endmodule