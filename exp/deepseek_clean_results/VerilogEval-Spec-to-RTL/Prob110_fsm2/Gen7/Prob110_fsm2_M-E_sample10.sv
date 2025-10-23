module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    wire t = (j & ~state) | (k & state);
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else if (t) begin
            state <= ~state;
        end
    end
    
    assign out = state;
endmodule