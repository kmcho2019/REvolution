module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    
    // Toggle logic: (j & ~state) | (k & state)
    wire toggle = (j & ~state) | (k & state);
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to OFF
        end else if (toggle) begin
            state <= ~state; // Toggle state
        end
    end
    
    assign out = state;
endmodule