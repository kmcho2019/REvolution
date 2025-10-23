module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    // One-hot state encoding
    parameter OFF = 2'b01;
    parameter ON  = 2'b10;
    
    reg [1:0] state, next_state;
    
    // State transition logic
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
    
    // Output logic - Moore style
    assign out = (state == ON);
endmodule