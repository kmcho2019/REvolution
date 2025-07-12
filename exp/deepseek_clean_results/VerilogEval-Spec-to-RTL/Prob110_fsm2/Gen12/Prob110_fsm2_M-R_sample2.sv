module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    
    // State transition logic
    wire next_state = state ? ~k : j;
    
    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) state <= 0;
        else state <= next_state;
    end
    
    // Output logic (Moore style)
    assign out = state;
endmodule