module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State definitions for clarity
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else case (state)
            OFF: state <= j ? ON : OFF;
            ON:  state <= k ? OFF : ON;
        endcase
    end
    
    // Direct output assignment
    assign out = state;
    
endmodule