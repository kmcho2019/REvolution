module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg state, next_state;

    // Combinational state transition logic
    always @(*) begin
        case (state)
            STATE_B: next_state = in ? STATE_B : STATE_A;
            STATE_A: next_state = in ? STATE_A : STATE_B;
            default: next_state = STATE_B;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= next_state;
    end

    // Output logic
    assign out = (state == STATE_B);

endmodule