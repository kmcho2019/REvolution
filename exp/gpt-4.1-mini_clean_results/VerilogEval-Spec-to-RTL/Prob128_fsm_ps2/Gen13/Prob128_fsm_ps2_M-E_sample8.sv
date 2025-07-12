module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Define FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;
            // done is asserted only when leaving BYTE2 state (third byte received)
            if (state == BYTE2) begin
                done <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: begin
                if (in[3])  // New start byte, restart message
                    next_state = BYTE1;
                else
                    next_state = BYTE2;
            end
            BYTE2: begin
                if (in[3])  // New start byte detected early, restart
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule