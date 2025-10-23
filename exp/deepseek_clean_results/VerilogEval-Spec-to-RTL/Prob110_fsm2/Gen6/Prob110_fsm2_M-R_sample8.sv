module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    // One-hot state encoding
    reg state_OFF;
    reg state_ON;
    
    // Next state logic (combinational)
    wire next_OFF = (state_OFF & ~j) | (state_ON & k);
    wire next_ON  = (state_OFF & j) | (state_ON & ~k);
    
    // State registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_OFF <= 1'b1;
            state_ON  <= 1'b0;
        end else begin
            state_OFF <= next_OFF;
            state_ON  <= next_ON;
        end
    end
    
    // Output logic
    assign out = state_ON;
endmodule