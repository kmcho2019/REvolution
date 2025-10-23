module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    reg state;  // 0=A, 1=B
    
    // Optimized state transition: next_state = in ? state : ~state
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to B
        end else begin
            state <= in ? state : ~state;
        end
    end

    // Direct output assignment
    assign out = state;
endmodule