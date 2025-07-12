module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    wire toggle;
    
    // Toggle when either:
    // - In OFF state and j is high
    // - In ON state and k is high
    assign toggle = (state & k) | (~state & j);
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else if (toggle) begin
            state <= ~state;
        end
    end
    
    assign out = state;
endmodule