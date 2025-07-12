module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0=A, 1=B
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            state <= in ? state : ~state;  // Toggle state if input is 0
        end
    end
    
    assign out = state;  // Direct state output
    
endmodule