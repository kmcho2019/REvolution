module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    typedef enum reg [1:0] {
        IDLE  = 2'd0,  // no bits matched
        S1    = 2'd1,  // matched '1'
        S2    = 2'd2,  // matched "11"
        FOUND = 2'd3   // matched "1101"
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == FOUND)
                start_shifting <= 1'b1;  // latch start_shifting on detection
        end
    end

    always @(*) begin
        case (state)
            IDLE:  next_state = data ? S1  : IDLE;
            S1:    next_state = data ? S2  : IDLE;
            S2:    next_state = data ? S2  : FOUND; // matched "110"
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

endmodule