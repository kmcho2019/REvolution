module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state = 0;  // Initial state OFF
    
    always @(posedge clk or posedge areset)
        state <= areset ? 0 : (state ? ~k : j);
    
    assign out = state;
endmodule