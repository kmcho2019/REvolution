module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

// FSM states
localparam IDLE     = 2'd0;
localparam LOAD_DELAY = 2'd1;
localparam COUNTING = 2'd2;
localparam DONE     = 2'd3;

reg [1:0] state, next_state;

// Shift register for input bits (pattern detection or delay loading)
reg [3:0] shift_reg;
reg [2:0] load_bit_cnt; // count of bits loaded in LOAD_DELAY (0..4)

// Counters
reg [9:0] cycle_counter;   // counts 0..999 clock cycles per segment
reg [3:0] segment_count;   // counts remaining segments (delay..0)

// Pattern to detect: 1101
localparam [3:0] PATTERN = 4'b1101;

// Sequential state update
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Shift register and counters sequential logic
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'd0;
        load_bit_cnt <= 3'd0;
        cycle_counter <= 10'd0;
        segment_count <= 4'd0;
    end else begin
        case(state)
            IDLE: begin
                // Shift in data bits serially each clock
                shift_reg <= {shift_reg[2:0], data};
                load_bit_cnt <= 3'd0;
                cycle_counter <= 10'd0;
                segment_count <= 4'd0;
            end
            LOAD_DELAY: begin
                // Shift in delay bits MSB first: shift left, insert data at LSB
                shift_reg <= {shift_reg[2:0], data};
                load_bit_cnt <= load_bit_cnt + 1'b1;
                cycle_counter <= 10'd0;
                segment_count <= 4'd0;
            end
            COUNTING: begin
                load_bit_cnt <= 3'd0;
                // Increment cycle counter, reset at 999
                if (cycle_counter == 10'd999) begin
                    cycle_counter <= 10'd0;
                    // Decrement segment counter if >0
                    if (segment_count != 4'd0)
                        segment_count <= segment_count - 1'b1;
                    else
                        segment_count <= segment_count; // hold at 0
                end else begin
                    cycle_counter <= cycle_counter + 1'b1;
                    segment_count <= segment_count;
                end
                shift_reg <= shift_reg; // hold shift_reg
            end
            DONE: begin
                // Hold all counters
                shift_reg <= shift_reg;
                load_bit_cnt <= 3'd0;
                cycle_counter <= 10'd0;
                segment_count <= 4'd0;
            end
        endcase
    end
end

// FSM next state logic
always @(*) begin
    next_state = state;
    case(state)
        IDLE: begin
            if (shift_reg == PATTERN)
                next_state = LOAD_DELAY;
            else
                next_state = IDLE;
        end
        LOAD_DELAY: begin
            if (load_bit_cnt == 3'd4)
                next_state = COUNTING;
            else
                next_state = LOAD_DELAY;
        end
        COUNTING: begin
            // Done counting when segment_count==0 and cycle_counter==999
            if (segment_count == 4'd0 && cycle_counter == 10'd999)
                next_state = DONE;
            else
                next_state = COUNTING;
        end
        DONE: begin
            if (ack)
                next_state = IDLE;
            else
                next_state = DONE;
        end
        default: next_state = IDLE;
    endcase
end

// On transition to COUNTING state, load segment_count = delay (loaded in shift_reg)
always @(posedge clk) begin
    if (reset) begin
        // reset done earlier
    end else if (state == LOAD_DELAY && next_state == COUNTING) begin
        // On crossing from LOAD_DELAY to COUNTING
        // segment_count = delay (4 bits in shift_reg), which is the delay value
        // We count (delay+1)*1000 cycles total by counting segments from delay down to 0 (delay+1 segments)
        // segment_count counts down from delay to 0 inclusive, so total segments = delay + 1
        segment_count <= shift_reg;
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
            IDLE, LOAD_DELAY: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0; // don't care value
            end
            COUNTING: begin
                counting <= 1'b1;
                done <= 1'b0;
                count <= segment_count;
            end
            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'd0; // don't care value
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