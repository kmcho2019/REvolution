module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    // State encoding (clear definitions)
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;
    
    // Compact state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;  // Async reset to OFF
        end else begin
            state <= state ? ~k : j;  // Efficient transition logic
        end
    end
    
    // Direct output assignment
    assign out = (state == ON);
endmodule