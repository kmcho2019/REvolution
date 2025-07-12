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
        BYTE3
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 1'b0;
        end else begin
            current_state <= next_state;
            // Done is asserted only in the cycle after receiving the third byte
            done <= (current_state == BYTE3);
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: begin
                next_state = (in[3]) ? BYTE2 : IDLE;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = (in[3]) ? BYTE2 : IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule