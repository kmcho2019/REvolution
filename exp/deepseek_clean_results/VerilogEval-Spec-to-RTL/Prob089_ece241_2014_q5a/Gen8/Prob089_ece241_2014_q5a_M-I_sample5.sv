module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Define states more clearly
    typedef enum logic {
        STATE_COPY,
        STATE_INVERT
    } state_t;
    
    state_t state, next_state;

    // Combinational output logic
    assign z = (state == STATE_COPY) ? x : ~x;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_COPY:   next_state = x ? STATE_INVERT : STATE_COPY;
            STATE_INVERT: next_state = STATE_INVERT;
        endcase
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_COPY;
        end else begin
            state <= next_state;
        end
    end

endmodule