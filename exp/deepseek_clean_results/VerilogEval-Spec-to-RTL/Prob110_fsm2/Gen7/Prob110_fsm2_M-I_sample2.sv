module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= state ? (k ? OFF : ON) : (j ? ON : OFF);
        end
    end
    
    assign out = state;
endmodule