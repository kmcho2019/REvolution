module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    wire toggle_enable = (state & k) | (~state & j);
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else if (toggle_enable) begin
            state <= ~state;
        end
    end
    
    assign out = state;
endmodule