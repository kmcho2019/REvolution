module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE       = 3'd0,
        START      = 3'd1,
        DATA       = 3'd2,
        STOP       = 3'd3,
        WAIT_STOP  = 3'd4
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] bit_cnt; // counts 0 to 7 for 8 data bits

    // Sequential state and bit counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done unless set below
            if (state == DATA) begin
                bit_cnt <= bit_cnt + 1;
            end else if (state == START) begin
                bit_cnt <= 3'd0;
            end

            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                // Confirm start bit still 0; then start reading data bits
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // false start bit, back to idle
            end
            DATA: begin
                // Collect 8 data bits, then go to STOP
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                // Check stop bit: must be 1
                if (in == 1'b1)
                    next_state = IDLE; // success, next byte
                else
                    next_state = WAIT_STOP; // wait for stop bit
            end
            WAIT_STOP: begin
                // Wait for stop bit to appear (line high)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule