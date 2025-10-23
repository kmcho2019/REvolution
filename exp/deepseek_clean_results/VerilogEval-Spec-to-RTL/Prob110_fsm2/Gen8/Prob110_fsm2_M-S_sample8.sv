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
            state <= 1'b0;
        end else begin
            state <= (state & ~k) | (~state & j);
        end
    end
    
    assign out = state;
endmodule