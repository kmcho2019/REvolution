module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    // State encoding
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;
    wire next_state;
    
    // Next state logic (combinational)
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON)  ? (k ? OFF : ON) :
                        OFF; // default case
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end
    
    // Output logic
    assign out = (state == ON);
endmodule