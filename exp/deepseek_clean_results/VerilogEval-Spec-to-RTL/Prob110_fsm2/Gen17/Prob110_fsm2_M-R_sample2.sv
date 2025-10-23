module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;
    wire next_state;
    
    // Next state logic
    assign next_state = (state == OFF) ? j : ~k;
    
    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) state <= OFF;
        else state <= next_state;
    end
    
    // Output logic
    assign out = state;
endmodule