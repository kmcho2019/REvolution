module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States for sequence detection
    typedef enum logic [2:0] {
        IDLE,
        GOT_1,
        GOT_11,
        GOT_110,
        DETECTED
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE:    next_state = data ? GOT_1 : IDLE;
            GOT_1:   next_state = data ? GOT_11 : IDLE;
            GOT_11:  next_state = data ? GOT_11 : GOT_110;
            GOT_110: next_state = data ? DETECTED : IDLE;
            DETECTED: next_state = DETECTED;
            default: next_state = IDLE;
        endcase
    end

    assign start_shifting = (current_state == DETECTED);

endmodule