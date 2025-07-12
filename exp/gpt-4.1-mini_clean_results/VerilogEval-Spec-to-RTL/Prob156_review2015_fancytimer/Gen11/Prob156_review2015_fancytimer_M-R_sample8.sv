module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

// States of FSM
localparam IDLE       = 3'd0; // Searching for pattern 1101
localparam LOAD_DELAY = 3'd1; // Loading 4 delay bits MSB first
localparam INIT_COUNT = 3'd2; // Initialize counters
localparam COUNT      = 3'd3; // Counting down cycles
localparam DONE       = 3'd4; // Done, wait ack

reg [2:0] state, next_state;

// Shift register for pattern detection (4 bits)
reg [3:0] pattern_shift;

// Delay register (4 bits)
reg [3:0] delay_reg;

// Bit count for delay loading (0 to 3)
reg [2:0] delay_bit_cnt;

// Cycle counter: counts 0..999 cycles
reg [9:0] cycle_counter;

// Segment counter: counts from delay+1 down to 0 segments
reg [3:0] segment_count;

// Pattern detection: check if pattern_shift == 1101
wire pattern_found = (pattern_shift == 4'b1101);

// FSM sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Pattern shift register update in IDLE state
always @(posedge clk) begin
    if (reset) begin
        pattern_shift <= 4'b0000;
    end else if (state == IDLE) begin
        pattern_shift <= {pattern_shift[2:0], data};
    end
end

// Delay loading shift register, shift left, insert data at LSB (MSB first)
always @(posedge clk) begin
    if (reset) begin
        delay_reg <= 4'b0000;
        delay_bit_cnt <= 3'd0;
    end else if (state == LOAD_DELAY) begin
        delay_reg <= {delay_reg[2:0], data};
        delay_bit_cnt <= delay_bit_cnt + 1'b1;
    end else if (state == IDLE) begin
        // Clear delay bits count and delay_reg when back to IDLE
        delay_reg <= 4'b0000;
        delay_bit_cnt <= 3'd0;
    end
end

// Cycle counter logic
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

// Segment counter logic
always @(posedge clk) begin
    if (reset) begin
        segment_count <= 4'd0;
    end else begin
        case(state)
            INIT_COUNT: begin
                // Load segment_count = delay + 1
                segment_count <= delay_reg + 1'b1;
            end
            COUNT: begin
                // Decrement segment_count at end of each 1000 cycle segment
                if (cycle_counter == 10'd999 && segment_count != 4'd0)
                    segment_count <= segment_count - 1'b1;
            end
            default: begin
                // Hold value
                segment_count <= segment_count;
            end
        endcase
    end
end

// FSM next state logic combinational
always @(*) begin
    next_state = state;
    case (state)
        IDLE: begin
            if (pattern_found)
                next_state = LOAD_DELAY;
        end
        LOAD_DELAY: begin
            if (delay_bit_cnt == 3'd4)
                next_state = INIT_COUNT;
        end
        INIT_COUNT: begin
            // Immediately move to COUNT on next clock
            next_state = COUNT;
        end
        COUNT: begin
            // When segment_count==0 and cycle_counter==999 counting done
            if (segment_count == 4'd0 && cycle_counter == 10'd999)
                next_state = DONE;
        end
        DONE: begin
            // Wait for ack to go back to IDLE
            if (ack)
                next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Outputs logic, synchronous with clk
always @(posedge clk) begin
    if (reset) begin
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0; // don't care assigned zero
            end
            LOAD_DELAY: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0; // don't care assigned zero
            end
            INIT_COUNT: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= segment_count; // showing initial delay+1
            end
            COUNT: begin
                counting <= 1'b1;
                done <= 1'b0;
                count <= segment_count;
            end
            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'd0; // don't care assigned zero
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