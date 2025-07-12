module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0=A, 1=B
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to B
        else if (state == 0)  // Current state A
            state <= in ? 1'b0 : 1'b1;
        else  // Current state B
            state <= in ? 1'b1 : 1'b0;
    end
    
    assign out = state;  // Direct output since B=1, A=0
    
endmodule