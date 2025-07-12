module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_B: next_state = in ? STATE_B : STATE_A;
            STATE_A: next_state = in ? STATE_A : STATE_B;
            default: next_state = STATE_B;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= next_state;
    end

    // Output logic (Moore machine)
    assign out = (state == STATE_B);

endmodule