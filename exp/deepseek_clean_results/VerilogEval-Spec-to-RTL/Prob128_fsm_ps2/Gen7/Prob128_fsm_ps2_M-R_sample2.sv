module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE,
        BYTE1,
        BYTE2,
        BYTE3
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
        end else begin
            current_state <= next_state;
            // done is asserted only when we complete a message (transition from BYTE3 to IDLE)
            done <= (current_state == BYTE3);
        end
    end

    always @(*) begin
        case (current_state)
            IDLE:   next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = in[3] ? BYTE1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule