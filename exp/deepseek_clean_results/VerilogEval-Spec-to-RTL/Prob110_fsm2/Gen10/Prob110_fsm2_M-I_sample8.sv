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
            state <= 0;
        end else begin
            if (state) begin
                state <= ~k;  // ON state: stay ON unless k=1
            end else begin
                state <= j;   // OFF state: go ON if j=1
            end
        end
    end
    
    assign out = state;
endmodule