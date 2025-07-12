module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;
    
    // T-flipflop implementation with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end else if (state ^ ~in) begin
            state <= ~state;  // Toggle when condition met
        end
    end
    
    // Direct output assignment
    assign out = state;
    
endmodule