module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // T-flipflop implementation with custom enable
    reg state;
    
    // Toggle enable logic: toggle when (OFF and j) or (ON and k)
    wire toggle_en = (state ? k : j);
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to OFF
        else if (toggle_en)
            state <= ~state; // Toggle state when enabled
    end
    
    assign out = state;
    
endmodule