module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    wire next_state;
    
    // Combinational next state logic
    assign next_state = state ? ~k : j;
    
    // DFF with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else
            state <= next_state;
    end
    
    // Output logic
    assign out = state;
endmodule