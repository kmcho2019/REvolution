module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else if (state) begin
            state <= ~k;
        end else begin
            state <= j;
        end
    end
    
    assign out = state;
endmodule