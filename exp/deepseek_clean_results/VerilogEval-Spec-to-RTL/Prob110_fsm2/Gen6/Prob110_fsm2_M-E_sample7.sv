module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to OFF
        end else begin
            // Combined transition logic:
            // (state AND NOT k) OR (NOT state AND j)
            state <= (state & ~k) | (~state & j);
        end
    end
    
    assign out = state;
endmodule