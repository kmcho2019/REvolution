module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State definitions
    typedef enum reg [2:0] {
        IDLE            = 3'd0,
        START_BIT_WAIT  = 3'd1,
        DATA_RECEIVE    = 3'd2,
        STOP_BIT_CHECK  = 3'd3,
        STOP_BIT_WAIT   = 3'd4
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt;       // Counts 0 to 7 data bits
    reg [7:0] shift_reg;

    // Next state logic and outputs
    always @(*) begin
        next_state = state;
        done = 1'b0;

        case(state)
            IDLE: begin
                // Wait for line to go low (start bit)
                if (in == 1'b0)
                    next_state = START_BIT_WAIT;
                else
                    next_state = IDLE;
            end

            START_BIT_WAIT: begin
                // Confirm start bit stays low next clock
                if (in == 1'b0)
                    next_state = DATA_RECEIVE;
                else
                    next_state = IDLE;  // false start, back to idle
            end

            DATA_RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP_BIT_CHECK;
                else
                    next_state = DATA_RECEIVE;
            end

            STOP_BIT_CHECK: begin
                if (in == 1'b1)  // valid stop bit
                    next_state = IDLE;
                else
                    next_state = STOP_BIT_WAIT;
            end

            STOP_BIT_WAIT: begin
                if (in == 1'b1)  // wait for stop bit to become high
                    next_state = IDLE;
                else
                    next_state = STOP_BIT_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // State update and sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;

            case(state)
                IDLE: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START_BIT_WAIT: begin
                    // nothing to do here besides state transition
                end

                DATA_RECEIVE: begin
                    // Shift right, new bit comes into MSB (to get LSB-first)
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_cnt < 3'd7)
                        bit_cnt <= bit_cnt + 1;
                end

                STOP_BIT_CHECK: begin
                    if (in == 1'b1)
                        done <= 1'b1; // done pulse asserted for one cycle
                end

                STOP_BIT_WAIT: begin
                    // just wait for stop bit high, no updates
                end
            endcase
        end
    end

endmodule