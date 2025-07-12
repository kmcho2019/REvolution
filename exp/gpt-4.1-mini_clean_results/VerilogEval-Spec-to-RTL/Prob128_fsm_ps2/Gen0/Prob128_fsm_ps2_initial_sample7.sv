module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {IDLE, BYTE2, BYTE3} state_t;
    state_t state, next_state;

    // Sequential FSM state update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is only asserted for one cycle in BYTE3 reception
            done <= (state == BYTE3);
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                // second byte received unconditionally
                next_state = BYTE3;
            end
            BYTE3: begin
                // after third byte, done is signaled,
                // then go back to IDLE to find next message start
                if (in[3] == 1'b1)
                    // If the byte itself marks start of a new message, start counting next message
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule