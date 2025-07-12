module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State definitions
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic
    assign out = (state == ON);

endmodule