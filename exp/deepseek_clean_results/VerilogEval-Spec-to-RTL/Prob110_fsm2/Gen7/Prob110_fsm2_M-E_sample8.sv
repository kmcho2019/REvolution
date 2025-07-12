module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    
    // T-flipflop implementation with custom enable
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else begin
            // Toggle when: (OFF and j) or (ON and k)
            state <= state ^ (state ? k : j);
        end
    end
    
    assign out = state;
endmodule