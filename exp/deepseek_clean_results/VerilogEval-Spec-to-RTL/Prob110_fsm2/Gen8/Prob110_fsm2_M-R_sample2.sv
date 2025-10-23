module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    wire next_state;
    
    // Next state logic (combinational)
    assign next_state = state ^ (state ? k : j);
    
    // DFF with async reset (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else begin
            state <= next_state;
        end
    end
    
    assign out = state;
endmodule