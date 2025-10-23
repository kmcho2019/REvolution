module TopModule (
    input clk,
    input reset,  // synchronous active high
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam SEARCH     = 3'd0;
    localparam LOAD_DELAY = 3'd1;
    localparam COUNTING   = 3'd2;
    localparam DONE       = 3'd3;

    reg [2:0] state, next_state;

    // Shift register to detect pattern 1101 on incoming data (last 4 bits)
    reg [3:0] pattern_shift;

    // Delay register to hold the 4 delay bits
    reg [3:0] delay;

    // Counter for delay cycles: counts down total clock cycles = (delay+1)*1000
    reg [12:0] cycle_count; // Enough bits to count up to 16000 (max 16,000 cycles)
    
    // Subcounter to generate the 1000 clock cycle ticks per delay decrement
    // We count 0..999 = 1000 cycles per step of delay
    // For each 1000 clocks decrement delay by 1 until done
    reg [9:0] subcount; // 10 bits for 0 to 999

    // Internal register for the delay counter steps (0 to delay) counting down
    reg [3:0] delay_countdown;

    // Detect pattern 1101 in last 4 bits of pattern_shift
    wire pattern_detected = (pattern_shift == 4'b1101);

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            cycle_count <= 13'd0;
            subcount <= 10'd0;
            delay_countdown <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
            SEARCH: begin
                done <= 1'b0;
                counting <= 1'b0;
                // Shift in data into pattern_shift
                pattern_shift <= {pattern_shift[2:0], data};
                // count output don't-care here, will keep last or zero
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first: shift left and input data into LSB
                // We'll shift in 4 bits: shift delay left, input data LSB
                delay <= {delay[2:0], data};
            end

            COUNTING: begin
                counting <= 1'b1;
                done <= 1'b0;
                // subcount increments each clk cycle
                if(subcount == 10'd999) begin
                    subcount <= 10'd0;
                    if (delay_countdown != 0)
                        delay_countdown <= delay_countdown - 1'b1;
                    // else delay_countdown == 0 do nothing here
                end else begin
                    subcount <= subcount + 1'b1;
                end
                // count shows delay_countdown
                count <= delay_countdown;
            end

            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                // keep outputs stable until ack
            end
            endcase
        end
    end

    // Next state logic and control signals
    reg [2:0] load_delay_bitcount; // counts how many delay bits shifted in (0..3)

    always @(*) begin
        // Default assignments
        next_state = state;

        case(state)
        SEARCH: begin
            // Wait until pattern_detected, then go to LOAD_DELAY, reset delay shift count
            if(pattern_detected) begin
                next_state = LOAD_DELAY;
            end
        end

        LOAD_DELAY: begin
            // After shifting in 4 delay bits, move to COUNTING
            if (load_delay_bitcount == 4) begin
                next_state = COUNTING;
            end
        end

        COUNTING: begin
            // Count down delay_countdown (which counts steps from delay to 0)
            // When delay_countdown == 0 and subcount completed 1000 cycles (subcount==999 and next cycle)
            if ((delay_countdown == 0) && (subcount == 10'd999)) begin
                next_state = DONE;
            end
        end

        DONE: begin
            // Wait until ack is high, then go back to SEARCH
            if (ack) begin
                next_state = SEARCH;
            end
        end

        default: next_state = SEARCH;
        endcase
    end

    // load_delay_bitcount sequential logic and controls
    always @(posedge clk) begin
        if(reset) begin
            load_delay_bitcount <= 3'd0;
        end else begin
            if(state == LOAD_DELAY) begin
                load_delay_bitcount <= load_delay_bitcount + 1'b1;
            end else begin
                load_delay_bitcount <= 3'd0;
            end
        end
    end

    // Initialize delay_countdown and cycle_count when entering COUNTING
    reg state_counting_prev;
    always @(posedge clk) begin
        if(reset) begin
            state_counting_prev <= 1'b0;
        end else begin
            state_counting_prev <= (state == COUNTING);

            // On state transition into COUNTING: load delay_countdown and reset counters
            if((!state_counting_prev) && (state == COUNTING)) begin
                delay_countdown <= delay;
                subcount <= 10'd0;
                count <= delay; // initial count value during first 1000 cycles
            end

            // When ack received in DONE state, also clear done and prepare to search again
            if(state == DONE && ack) begin
                done <= 1'b0;
                count <= 4'b0;
                pattern_shift <= 4'b0;
                delay <= 4'b0;
            end
        end
    end

endmodule