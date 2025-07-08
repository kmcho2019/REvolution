module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam SEARCH      = 2'd0;
    localparam SHIFT_DELAY = 2'd1;
    localparam COUNTING    = 2'd2;
    localparam DONE        = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for detecting pattern 1101
    reg [3:0] pattern_shift;

    // Delay bits collected
    reg [3:0] delay;

    // Shift delay bits counter
    reg [2:0] shift_cnt; // counts 0 to 3 for 4 bits

    // 10-bit counter for 1000 cycles
    reg [9:0] cycle_cnt;

    // Remaining delay count during counting
    reg [3:0] remaining_delay;

    // Sequential logic for FSM state transition and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            shift_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            remaining_delay <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data bit
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                SHIFT_DELAY: begin
                    // Shift in delay bits MSB first
                    delay <= {delay[2:0], data};
                    shift_cnt <= shift_cnt + 1;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= remaining_delay;

                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        if (remaining_delay != 4'd0)
                            remaining_delay <= remaining_delay - 1;
                        else
                            remaining_delay <= 4'd0;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            endcase

            // Clear counting and done outputs and count when not in those states
            if (state != COUNTING) counting <= 1'b0;
            if (state != DONE) done <= 1'b0;

            if (state == SEARCH) begin
                count <= 4'bxxxx; // don't care, but assign X for clarity
                shift_cnt <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Check pattern 1101 (binary 4'b1101)
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT_DELAY;
                else
                    next_state = SEARCH;
            end

            SHIFT_DELAY: begin
                if (shift_cnt == 3'd3) // collected 4 bits now
                    next_state = COUNTING;
                else
                    next_state = SHIFT_DELAY;
            end

            COUNTING: begin
                // When counting finishes, transition to DONE
                // counting lasts (delay+1)*1000 cycles
                // counting decrements remaining_delay each 1000 cycles
                // finish when remaining_delay == 0 and cycle_cnt == 999
                if ((remaining_delay == 4'd0) && (cycle_cnt == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end
        endcase
    end

    // Load delay and remaining_delay at SHIFT_DELAY to COUNTING transition
    always @(posedge clk) begin
        if (reset) begin
            remaining_delay <= 4'd0;
        end else begin
            if ((state == SHIFT_DELAY) && (shift_cnt == 3'd3)) begin
                // delay already shifted in
                remaining_delay <= {delay[2:0], data}; // This is done in main always block, but here make sure remaining_delay updated
            end
        end
    end

endmodule