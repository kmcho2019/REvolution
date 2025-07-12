module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    
    always @(posedge clk or posedge areset)
        if (areset) state <= 0;
        else state <= state ? ~k : j;
    
    assign out = state;
endmodule