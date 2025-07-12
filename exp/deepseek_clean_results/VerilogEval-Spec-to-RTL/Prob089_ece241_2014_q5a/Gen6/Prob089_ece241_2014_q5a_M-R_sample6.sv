module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Define states
    parameter STATE_PASS = 1'b0;
    parameter STATE_INVERT = 1'b1;
    
    reg state;
    reg next_state;
    
    // State transition logic
    always @(*) begin
        case (state)
            STATE_PASS:   next_state = x ? STATE_INVERT : STATE_PASS;
            STATE_INVERT: next_state = STATE_INVERT;
        endcase
    end
    
    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
        end else begin
            state <= next_state;
        end
    end
    
    // Output logic (combinational)
    assign z = (state == STATE_PASS) ? x : ~x;

endmodule