module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding
    localparam [1:0]
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3;

    reg [1:0] state, state_next;

    // Continuous pattern shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register and bits loaded count (to load 4 bits MSB-first)
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded; // counts 0..4

    // Counters for counting phase
    reg [9:0] cycle_counter;    // counts down 999..0
    reg [3:0] segment_counter;  // counts down delay+1 .. 0

    // Pattern found signal (updated each clock)
    wire pattern_found = (pattern_shift == 4'b1101);

    // Pattern shift register updates every clock (serial input always shifted in)
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH;
        else
            state <= state_next;
    end

    // State next logic
    always @(*) begin
        case (state)
            SEARCH: begin
                if (pattern_found)
                    state_next = LOAD_DELAY;
                else
                    state_next = SEARCH;
            end
            LOAD_DELAY: begin
                if (delay_bits_loaded == 3'd4)
                    state_next = COUNT;
                else
                    state_next = LOAD_DELAY;
            end
            COUNT: begin
                if (segment_counter == 0 && cycle_counter == 0)
                    state_next = WAIT_ACK;
                else
                    state_next = COUNT;
            end
            WAIT_ACK: begin
                if (ack)
                    state_next = SEARCH;
                else
                    state_next = WAIT_ACK;
            end
            default: state_next = SEARCH;
        endcase
    end

    // Registers updated on clock, separate logic for load delay bits and counting

    // Load delay and delay_bits_loaded registers
    always @(posedge clk) begin
        if (reset) begin
            delay <= 4'b0000;
            delay_bits_loaded <= 3'd0;
        end else begin
            if (state == LOAD_DELAY) begin
                // Shift in delay bits MSB first, one bit per clock from data input
                // Shift left and insert data bit at LSB
                delay <= {delay[2:0], data};
                delay_bits_loaded <= delay_bits_loaded + 1'b1;
            end else begin
                delay_bits_loaded <= 3'd0; // reset counter outside LOAD_DELAY
            end
        end
    end

    // Counters for counting timing
    // Initialize counters on entry to COUNT state
    reg count_start_pulse; // one clock pulse indicating count start
    reg [1:0] state_d; // delayed state for edge detect

    always @(posedge clk) begin
        if (reset) begin
            state_d <= 2'b00;
        end else begin
            state_d <= {state_d[0], state};
        end
    end

    // Detect rising edge of COUNT state (previous != COUNT && current == COUNT)
    always @(posedge clk) begin
        if (reset) begin
            count_start_pulse <= 1'b0;
        end else begin
            count_start_pulse <= (state_d[0] != COUNT) && (state == COUNT);
        end
    end

    // Cycle and segment counters management
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 10'd0;
            segment_counter <= 4'd0;
        end else begin
            if (count_start_pulse) begin
                // Initialize counters at start of counting
                cycle_counter <= 10'd999;                // counts 0..999 == 1000 cycles
                segment_counter <= delay + 1'b1;         // number of 1000-cycle segments
            end else if (state == COUNT) begin
                if (cycle_counter == 0) begin
                    if (segment_counter != 0) begin
                        segment_counter <= segment_counter - 1'b1;
                        cycle_counter <= 10'd999;
                    end
                end else begin
                    cycle_counter <= cycle_counter - 1'b1;
                end
            end else begin
                // Hold counters in other states
                cycle_counter <= cycle_counter;
                segment_counter <= segment_counter;
            end
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            case (state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't-care, output zero for convenience
                end
                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't-care
                end
                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Calculate the current remaining count per spec:
                    // count = current segment_counter - 1 when cycle_counter > 0
                    //       = current segment_counter when cycle_counter == 0

                    if (cycle_counter == 0)
                        count <= segment_counter;
                    else if (segment_counter != 0)
                        count <= segment_counter - 1'b1;
                    else
                        count <= 4'd0; // no segments remaining, safety fallback
                end
                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000; // don't-care or zero
                end
                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase
        end
    end

endmodule