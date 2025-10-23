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
typedef enum reg [1:0] {
    SEARCH      = 2'b00,
    LOAD_DELAY  = 2'b01,
    COUNT       = 2'b10,
    DONE_WAIT_ACK = 2'b11
} state_t;

reg [1:0] state, state_next;

// Shift register for pattern detection
reg [3:0] pattern_shift;

// Delay loading
reg [3:0] delay_reg;
reg [2:0] delay_bit_cnt; // count 0..4 bits loaded

// Cycle counter counts clock cycles within each 1000 cycle segment
reg [9:0] cycle_counter;  // enough for 0..999

// Down counter for number of segments left (delay+1 segments of 1000 cycles)
reg [3:0] segment_count;  // counts from delay down to 0

// Detect start pattern 1101 (MSB first in shift reg)
wire pattern_found = (pattern_shift == 4'b1101);

// FSM sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= SEARCH;
    end else begin
        state <= state_next;
    end
end

// Pattern shift register: shift in data every clk in SEARCH state
always @(posedge clk) begin
    if (reset) begin
        pattern_shift <= 4'b0000;
    end else if (state == SEARCH) begin
        pattern_shift <= {pattern_shift[2:0], data};
    end
end

// Delay loading shift register, MSB first: shift left, insert data at LSB
always @(posedge clk) begin
    if (reset) begin
        delay_reg <= 4'b0000;
        delay_bit_cnt <= 3'd0;
    end else if (state == LOAD_DELAY) begin
        // Shift left, insert data as LSB (MSB first means first loaded bit goes into MSB)
        delay_reg <= {delay_reg[2:0], data};
        delay_bit_cnt <= delay_bit_cnt + 1'b1;
    end else if (state == SEARCH) begin
        // Clear delay bits count and delay_reg when going back to SEARCH
        delay_bit_cnt <= 3'd0;
        delay_reg <= 4'b0000;
    end
end

// Cycle counter: counts 0..999, resets at 999
always @(posedge clk) begin
    if (reset) begin
        cycle_counter <= 10'd0;
    end else if (state == COUNT) begin
        if (cycle_counter == 10'd999)
            cycle_counter <= 10'd0;
        else
            cycle_counter <= cycle_counter + 1'b1;
    end else begin
        cycle_counter <= 10'd0;
    end
end

// Segment counter: counts down from delay_reg to 0, decrements every 1000 cycles
always @(posedge clk) begin
    if (reset) begin
        segment_count <= 4'd0;
    end else begin
        case(state)
            LOAD_DELAY: begin
                // At the moment we finish loading delay bits, initialize segment_count
                if (delay_bit_cnt == 3'd3) begin
                    // Will have loaded last bit this cycle (delay_bit_cnt goes 0..3)
                    // So delay_reg after this shift is valid next cycle, assign segment_count next cycle
                    // We assign in state_next logic to avoid glitches
                end
            end
            COUNT: begin
                // At end of each 1000 cycle segment (cycle_counter == 999), decrement segment_count
                if (cycle_counter == 10'd999) begin
                    if (segment_count != 4'd0)
                        segment_count <= segment_count - 1'b1;
                end
            end
            default: segment_count <= segment_count;
        endcase
    end
end

// To avoid combinational feedback, use a register to load segment_count at LOAD_DELAY -> COUNT transition
reg load_segment_count;

// This signal is set when delay loading is completed (delay_bit_cnt == 4)
always @(posedge clk) begin
    if (reset) begin
        load_segment_count <= 1'b0;
    end else if (state == LOAD_DELAY && delay_bit_cnt == 3'd4) begin
        load_segment_count <= 1'b1;
    end else begin
        load_segment_count <= 1'b0;
    end
end

// Load segment_count register on transition from LOAD_DELAY to COUNT, using load_segment_count pulse
always @(posedge clk) begin
    if (reset) begin
        segment_count <= 4'd0;
    end else if (load_segment_count) begin
        segment_count <= delay_reg + 1'b1; // (delay + 1)
    end
end

// FSM next state logic
always @(*) begin
    state_next = state;
    case(state)
        SEARCH: begin
            if (pattern_found)
                state_next = LOAD_DELAY;
        end
        LOAD_DELAY: begin
            if (delay_bit_cnt == 3'd4)
                state_next = COUNT;
        end
        COUNT: begin
            // When segment_count reaches zero and cycle_counter == 999, counting done
            if ((segment_count == 4'd0) && (cycle_counter == 10'd999))
                state_next = DONE_WAIT_ACK;
        end
        DONE_WAIT_ACK: begin
            if (ack)
                state_next = SEARCH;
        end
    endcase
end

// Output logic
always @(posedge clk) begin
    if (reset) begin
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0000;
    end else begin
        case(state)
            SEARCH: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'bxxxx;  // don't care per spec
            end
            LOAD_DELAY: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'bxxxx;  // don't care while loading delay bits
            end
            COUNT: begin
                counting <= 1'b1;
                done <= 1'b0;
                count <= segment_count;
            end
            DONE_WAIT_ACK: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'bxxxx; // don't care while waiting ack
            end
            default: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'bxxxx;
            end
        endcase
    end
end

endmodule