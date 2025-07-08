module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] bit_cnt;       // Counts from 0 to 7 for data bits
    reg [7:0] shift_reg;

    // Sequential logic for state, counters, and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default done low, asserted for one cycle only

            case(state)
                IDLE: begin
                    // Wait for start bit (line goes low)
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START: begin
                    // Nothing else to do here, just move on next cycle
                end

                DATA: begin
                    // Shift in data bits LSB first on each clock
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit, data byte done
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end

                WAIT_STOP: begin
                    // Just wait for stop bit to be 1, no other action
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end

            START: begin
                // Confirm start bit still 0
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // False start, go back to idle
            end

            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP; // Bad stop bit, wait for stop
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // Once stop bit found, ready for next byte
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule