module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;
    reg next_state;
    
    // Next state logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end
    
    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) state <= OFF;
        else state <= next_state;
    end
    
    // Output logic (Moore style)
    assign out = (state == ON);
endmodule