module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        DATA = 2'b01,
        STOP_WAIT = 2'b10,
        ERROR_WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt; // 3 bits to count 0..7 data bits

    // Sequential state and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, except when asserted below
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                end
                DATA: begin
                    bit_cnt <= bit_cnt + 3'd1;
                end
                STOP_WAIT: begin
                    // done asserted for one cycle when valid stop bit
                    if (in == 1'b1)
                        done <= 1'b1;
                    bit_cnt <= 3'd0;
                end
                ERROR_WAIT_STOP: begin
                    bit_cnt <= 3'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA; // start bit detected
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = DATA;
            end
            STOP_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE; // valid stop bit, ready for next byte
                else
                    next_state = ERROR_WAIT_STOP; // invalid stop bit, error
            end
            ERROR_WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule