module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // States
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_shift;    // shift register for pattern detection
    reg [2:0] load_count;       // count loaded delay bits (0 to 4)
    reg [3:0] delay_reg;        // delay bits loaded MSB first

    reg [19:0] timer_counter;   // down counter for (delay+1)*1000 cycles

    // Update pattern shift register only in SEARCH state
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else if (state == SEARCH) begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // FSM state register
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            SEARCH:
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;

            LOAD_DELAY:
                if (load_count == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;

            COUNT:
                if (timer_counter == 20'd0)
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;

            WAIT_ACK:
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;

            default: next_state = SEARCH;
        endcase
    end

    // Load delay bits MSB first during LOAD_DELAY state
    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 4'd0;
            load_count <= 3'd0;
        end else if (state == LOAD_DELAY) begin
            // Shift delay left by 1, insert new bit at LSB
            delay_reg <= {delay_reg[2:0], data};
            load_count <= load_count + 1;
        end else begin
            load_count <= 3'd0;
        end
    end

    // Timer counter logic
    // Load timer_counter at start of COUNT state
    // Counts down each clock cycle until zero
    always @(posedge clk) begin
        if (reset) begin
            timer_counter <= 20'd0;
        end else if (state == LOAD_DELAY && load_count == 3'd4) begin
            // Start counting next cycle after delay loaded
            // (delay_reg + 1) * 1000 cycles
            timer_counter <= (({16'd0, delay_reg} + 1) * 20'd1000);
        end else if (state == COUNT) begin
            if (timer_counter != 0)
                timer_counter <= timer_counter - 1;
        end else begin
            timer_counter <= timer_counter;
        end
    end

    // Outputs logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            case(state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't-care
                end
                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't-care
                end
                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // Calculate remaining 1000-cycle segments minus 1
                    // segments_left = timer_counter / 1000
                    // count = segments_left - 1, saturate at 0
                    if (timer_counter >= 1000)
                        count <= (timer_counter / 1000) - 1;
                    else
                        count <= 4'd0;
                end
                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0; // don't-care
                end
                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

endmodule