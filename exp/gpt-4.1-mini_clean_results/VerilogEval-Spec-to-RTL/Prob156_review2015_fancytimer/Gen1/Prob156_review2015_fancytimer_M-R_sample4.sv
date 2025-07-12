module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // States definition
    localparam SEARCH      = 2'd0;
    localparam READ_DELAY  = 2'd1;
    localparam COUNT       = 2'd2;
    localparam DONE        = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection and delay bit reading:
    // During SEARCH: shift in 'data' LSB-first; check lower 4 bits for pattern 1101
    // When pattern detected, move to READ_DELAY, read 4 bits MSB-first into delay_reg
    reg [4:0] shift_reg;  // 5 bits to handle shifting in READ_DELAY cleanly

    reg [2:0] bits_read; // counts bits read in READ_DELAY (0 to 3)
    reg [3:0] delay_reg;

    // Counting variables
    reg [9:0] cycle_count;   // Counts 0..999 clock cycles
    reg [3:0] remaining;     // Counts delay down to 0 during COUNT

    // Output combinational logic
    assign counting = (state == COUNT);
    assign done = (state == DONE);

    // next_state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Check if lower 4 bits of shift_reg == 4'b1101
                if (shift_reg[3:0] == 4'b1101)
                    next_state = READ_DELAY;
            end
            READ_DELAY: begin
                // After reading 4 delay bits (bits_read counts 0..3)
                if (bits_read == 3'd4)
                    next_state = COUNT;
            end
            COUNT: begin
                // When finished counting all cycles (remaining==0 and cycle_count==999)
                if ((remaining == 4'd0) && (cycle_count == 10'd999))
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic: state transitions, input processing, counters
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 5'b0;
            bits_read <= 3'd0;
            delay_reg <= 4'd0;
            cycle_count <= 10'd0;
            remaining <= 4'd0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data LSB first (shift_reg[4] is oldest, [0] newest)
                    shift_reg <= {shift_reg[3:0], data};
                    bits_read <= 3'd0;  // clear bits_read before READ_DELAY
                    delay_reg <= 4'd0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    count <= 4'd0;
                end

                READ_DELAY: begin
                    // In READ_DELAY, shift delay bits MSB first into delay_reg
                    // We read one bit per cycle, most significant bit first:
                    // On each cycle, shift delay_reg left, input current data into LSB.
                    delay_reg <= {delay_reg[2:0], data};
                    bits_read <= bits_read + 1'b1;
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    // No change to shift_reg; stop pattern detection here
                end

                COUNT: begin
                    // On first cycle entering COUNT, if cycle_count==0 and remaining==0, load remaining=delay_reg
                    // We do this by checking if previous state was READ_DELAY

                    // Counting logic:
                    // increment cycle_count from 0..999
                    // when cycle_count == 999, reset to 0 and decrement remaining if remaining > 0
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (remaining != 4'd0)
                            remaining <= remaining - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    count <= remaining;
                    // shift_reg remains unchanged, no data input until done
                end

                DONE: begin
                    // Wait for ack to transition to SEARCH
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    bits_read <= 3'd0;
                    // shift_reg not changed here - it will be cleared on next SEARCH state
                end

                default: begin
                    // safety defaults
                    shift_reg <= 5'd0;
                    bits_read <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    count <= 4'd0;
                end
            endcase

            // Load remaining from delay_reg at the cycle the state changes from READ_DELAY to COUNT
            // Detect this by looking at previous state and current state
            // To do that, we keep prev_state register

        end
    end

    reg [1:0] prev_state;
    always @(posedge clk) begin
        if (reset) 
            prev_state <= SEARCH;
        else 
            prev_state <= state;
    end

    // On rising edge from READ_DELAY to COUNT, load remaining with delay_reg and reset cycle_count
    always @(posedge clk) begin
        if (reset) begin
            remaining <= 4'd0;
            cycle_count <= 10'd0;
        end else begin
            if ((prev_state == READ_DELAY) && (state == COUNT)) begin
                remaining <= delay_reg;
                cycle_count <= 10'd0;
            end
            // Else handled in COUNT state logic above
        end
    end

endmodule