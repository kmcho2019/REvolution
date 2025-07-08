module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // FSM states
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        ERROR = 3'd4
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count; // to count 8 data bits

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low, only set high when byte correctly received

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                end
                START: begin
                    bit_count <= 3'd0;
                end
                DATA: begin
                    bit_count <= bit_count + 3'd1;
                end
                STOP: begin
                    // bit_count stays same
                end
                ERROR: begin
                    // bit_count stays same
                end
            endcase
        end
    end

    // Next state logic and done output
    always @(*) begin
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = START;
                else
                    next_state = IDLE; // stay in idle while line is high
            end
            START: begin
                // Move immediately to DATA on next clock
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1; // correct stop bit detected, byte received
                    next_state = IDLE;
                end else begin
                    // Stop bit incorrect, go to error state
                    next_state = ERROR;
                end
            end
            ERROR: begin
                // Wait until in goes to 1 (stop bit), then return to IDLE
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule