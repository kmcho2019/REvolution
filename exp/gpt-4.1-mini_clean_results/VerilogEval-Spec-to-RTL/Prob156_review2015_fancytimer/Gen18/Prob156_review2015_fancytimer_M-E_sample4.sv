module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM States
    typedef enum reg [1:0] {
        SEARCH     = 2'b00,
        LOAD_DELAY = 2'b01,
        COUNT      = 2'b10,
        WAIT_ACK   = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection: 5 bits sliding window
    reg [4:0] shift_reg;

    // Delay register for 4 bits MSB first
    reg [3:0] delay;

    // Number of delay bits loaded (0 to 4)
    reg [2:0] delay_bit_count;

    // Cycle counter for counting (delay+1)*1000 cycles max (max 16k)
    // 14 bits to count up to 16000
    reg [13:0] cycle_count;

    // Constants
    localparam START_PATTERN = 4'b1101;

    // Pattern detection: top 4 bits of shift_reg
    wire start_detected = (shift_reg[4:1] == START_PATTERN);

    // Number of 1000-cycle segments remaining
    // Computed dynamically as ceil(cycle_count/1000)
    // But we count down from total cycles to 0, so segments = (cycle_count + 999)/1000
    // Use integer division with add to round up
    wire [3:0] segments_remaining = (cycle_count + 14'd999) / 14'd1000;

    // Synchronize outputs based on state
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 5'b0;
            delay <= 4'b0;
            delay_bit_count <= 3'b0;
            cycle_count <= 14'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'b0; // don't care, clear for convenience

                    // Shift left and input new bit at LSB to keep MSB first order
                    // Data stream: first bit is MSB, so newest bit at LSB
                    shift_reg <= {shift_reg[3:0], data};

                    // Reset delay loading registers
                    delay <= 4'b0;
                    delay_bit_count <= 3'b0;
                    cycle_count <= 14'b0;
                end

                LOAD_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;

                    // Shift in delay bits MSB first by shifting left and inputting new bit at LSB
                    delay <= {delay[2:0], data};
                    delay_bit_count <= delay_bit_count + 1'b1;

                    // Keep shift_reg unchanged during delay loading (optional)
                    shift_reg <= shift_reg;
                    count <= 4'b0;
                    cycle_count <= 14'b0;
                end

                COUNT: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // Keep shift_reg and delay_bit_count unchanged during counting
                    shift_reg <= shift_reg;
                    delay_bit_count <= delay_bit_count;

                    if (cycle_count != 0) begin
                        cycle_count <= cycle_count - 1'b1;
                    end

                    // Output the current segments remaining = (cycle_count+999)/1000
                    count <= segments_remaining;
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0; // don't care

                    // Clear registers, but keep shift_reg to zero to restart
                    shift_reg <= 5'b0;
                    delay <= 4'b0;
                    delay_bit_count <= 3'b0;
                    cycle_count <= 14'b0;
                end

                default: begin
                    // Safe defaults on unknown state
                    state <= SEARCH;
                    shift_reg <= 5'b0;
                    delay <= 4'b0;
                    delay_bit_count <= 3'b0;
                    cycle_count <= 14'b0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            SEARCH: begin
                if (start_detected) begin
                    next_state = LOAD_DELAY;
                end else begin
                    next_state = SEARCH;
                end
            end

            LOAD_DELAY: begin
                if (delay_bit_count == 3'd4) begin
                    next_state = COUNT;
                end else begin
                    next_state = LOAD_DELAY;
                end
            end

            COUNT: begin
                if (cycle_count == 14'd0) begin
                    next_state = WAIT_ACK;
                end else begin
                    next_state = COUNT;
                end
            end

            WAIT_ACK: begin
                if (ack) begin
                    next_state = SEARCH;
                end else begin
                    next_state = WAIT_ACK;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

    // On entering COUNT state, initialize cycle_count with (delay+1)*1000 cycles
    // Since we only know delay after LOAD_DELAY completes
    // We detect entering COUNT by next_state and state signals

    always @(posedge clk) begin
        if (reset) begin
            // Already reset above
        end else begin
            // When transitioning from LOAD_DELAY to COUNT, initialize cycle_count
            if (state == LOAD_DELAY && next_state == COUNT) begin
                // (delay + 1)*1000 cycles
                cycle_count <= (({10'b0, delay} + 1'b1) * 14'd1000);
            end
        end
    end

endmodule