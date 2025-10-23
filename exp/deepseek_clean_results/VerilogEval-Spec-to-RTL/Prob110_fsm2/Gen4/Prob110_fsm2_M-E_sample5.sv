module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state_OFF;  // Active high for OFF state
    reg state_ON;   // Active high for ON state
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_OFF <= 1'b1;
            state_ON  <= 1'b0;
        end else begin
            // OFF state logic
            state_OFF <= (state_OFF & ~j) | (state_ON & k);
            // ON state logic
            state_ON  <= (state_OFF & j) | (state_ON & ~k);
        end
    end
    
    assign out = state_ON;  // Output directly from ON state
endmodule