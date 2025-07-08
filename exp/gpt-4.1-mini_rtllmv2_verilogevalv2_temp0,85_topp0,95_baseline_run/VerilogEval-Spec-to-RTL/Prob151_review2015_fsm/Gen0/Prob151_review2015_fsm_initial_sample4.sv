module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // States
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        SHIFT = 2'd1,
        COUNT = 2'd2,
        DONE = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Counter for shift_ena cycles (4 cycles)
    reg [1:0] shift_cnt;

    // Next state logic and outputs combinational block
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                // Wait for pattern 1101 in pattern_shift
                if(pattern_shift == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if(shift_cnt == 2'd3) begin
                    next_state = COUNT;
                end
            end
            COUNT: begin
                counting = 1'b1;
                if(done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                done = 1'b1;
                if(ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Sequential block: state transitions, pattern shift, and counters
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_cnt <= 2'b00;
        end else begin
            state <= next_state;

            // Pattern shift only in IDLE state (when searching)
            if(state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end

            // Shift counter increments in SHIFT state, else reset
            if(state == SHIFT) begin
                shift_cnt <= shift_cnt + 1'b1;
            end else begin
                shift_cnt <= 2'b00;
            end
        end
    end

endmodule