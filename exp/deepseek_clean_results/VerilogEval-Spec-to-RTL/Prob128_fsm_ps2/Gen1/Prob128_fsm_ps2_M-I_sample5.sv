module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        BYTE2,
        BYTE3,
        DONE
    } state_t;

    // State register
    state_t state, next_state;

    // Sequential logic for state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // 'done' is asserted only in DONE state
            done <= (next_state == DONE);
        end
    end

    // Combinational logic for next state
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = DONE;
            end
            DONE: begin
                // After completing a message, look for next start byte
                if (in[3] == 1'b1) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule