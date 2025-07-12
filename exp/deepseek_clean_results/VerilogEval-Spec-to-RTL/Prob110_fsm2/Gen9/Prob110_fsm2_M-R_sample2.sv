module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    wire next_state;
    
    // Combinational next state logic
    assign next_state = (state & ~k) | (~state & j);
    
    // Sequential state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            state <= next_state;
        end
    end
    
    // Output assignment
    assign out = state;
endmodule