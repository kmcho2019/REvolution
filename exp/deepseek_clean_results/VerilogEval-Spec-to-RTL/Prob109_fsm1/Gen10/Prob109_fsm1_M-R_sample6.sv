module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0 for A, 1 for B
    
    wire next_state = state ? (in ? 1'b1 : 1'b0)  // State B transitions
                         : (in ? 1'b0 : 1'b1);   // State A transitions
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to state B
        else
            state <= next_state;
    end
    
    assign out = state;  // Output is directly the state bit
    
endmodule