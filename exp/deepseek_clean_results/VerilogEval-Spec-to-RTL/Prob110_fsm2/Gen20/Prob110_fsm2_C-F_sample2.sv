module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    
    // State transition with direct and clear logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else
            state <= state ? ~k : j;
    end
    
    // Moore output
    assign out = state;
endmodule