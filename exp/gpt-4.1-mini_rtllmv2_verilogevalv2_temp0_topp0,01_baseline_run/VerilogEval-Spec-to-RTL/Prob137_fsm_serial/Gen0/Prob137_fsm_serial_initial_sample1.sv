module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;

    reg [2:0] state, next_state;
    reg [3:0] bit_count; // to count 8 data bits
    reg [7:0] data_shift; // to shift in data bits

    // Sequential logic for state and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low, only high for one cycle when byte received correctly

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift <= 8'd0;
                end
                START: begin
                    // no counters updated here
                end
                DATA: begin
                    // shift in data bits LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // no counters updated here
                end
                WAIT_STOP: begin
                    // no counters updated here
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = START;
            end
            START: begin
                // Confirm start bit is still 0
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // false start bit, back to idle
            end
            DATA: begin
                if (bit_count == 4'd8)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic for done signal
    always @(posedge clk) begin
        if (!reset && state == STOP && in == 1'b1) begin
            done <= 1'b1;
        end
    end

endmodule