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
        end else if (state) begin
            if (k) state <= 0;
        end else begin
            if (j) state <= 1;
        end
    end
    
    assign out = state;
endmodule