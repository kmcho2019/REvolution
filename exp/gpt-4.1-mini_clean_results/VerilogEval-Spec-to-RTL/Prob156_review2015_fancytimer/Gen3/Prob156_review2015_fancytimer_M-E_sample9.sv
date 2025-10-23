module TopModule (
    input  wire       clk,
    input  wire       reset,    // synchronous active high
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

// FSM states
typedef enum reg [1:0] {
    IDLE       = 2'b00,
    LOAD_DELAY = 2'b01,
    COUNT      = 2'b10,
    DONE       = 2'b11
} state_t;

reg [1:0] state, next_state;

// Pattern detection shift register for 4 bits
reg [3:0] pattern_shift;

// Delay register
reg [3:0] delay_reg;

// Delay bit load counter (0 to 3)
reg [2:0] delay_load_cnt;

// Cycle counter for counting 0 to 999 clock cycles
reg [9:0] cycle_count_1000;

// Remaining delay counter (counts down from delay to 0, then -1 to indicate done)
reg signed [4:0] remaining_delay; // use signed so can go below zero to signal end

// State register and synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_shift <= 4'b0000;
        delay_reg <= 4'b0000;
        delay_load_cnt <= 3'd0;
        cycle_count_1000 <= 10'd0;
        remaining_delay <= 5'd0;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;

        case(state)
            IDLE: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000; // don't-care, but keep zero
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 5'd0;
                delay_load_cnt <= 3'd0;

                // Shift pattern shift register in with new data bit
                pattern_shift <= {pattern_shift[2:0], data};
            end

            LOAD_DELAY: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;

                // Shift in delay bits MSB first
                // Shift delay_reg left by 1, insert new bit at LSB
                delay_reg <= {delay_reg[2:0], data};

                delay_load_cnt <= delay_load_cnt + 1'b1;

                // pattern_shift held unchanged (optional)
                pattern_shift <= pattern_shift;
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 5'd0;
            end

            COUNT: begin
                done <= 1'b0;
                counting <= 1'b1;

                // Output current remaining delay (4 LSB bits)
                // remaining_delay >=0 guaranteed here
                count <= remaining_delay[3:0];

                // Increment cycle counter
                if (cycle_count_1000 == 10'd999) begin
                    cycle_count_1000 <= 10'd0;
                    remaining_delay <= remaining_delay - 1;
                end else begin
                    cycle_count_1000 <= cycle_count_1000 + 1;
                    remaining_delay <= remaining_delay;
                end

                // Hold delay_reg and pattern_shift stable
                delay_reg <= delay_reg;
                pattern_shift <= pattern_shift;
                delay_load_cnt <= delay_load_cnt;
            end

            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'b0000; // don't-care
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_load_cnt <= 3'd0;
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 5'd0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE: begin
            // Check for pattern 1101
            if (pattern_shift == 4'b1101)
                next_state = LOAD_DELAY;
            else
                next_state = IDLE;
        end

        LOAD_DELAY: begin
            // After 4 bits delay loaded, transition to COUNT
            if (delay_load_cnt == 3'd4)
                next_state = COUNT;
            else
                next_state = LOAD_DELAY;
        end

        COUNT: begin
            // Wait until remaining_delay < 0 to move to DONE
            if (remaining_delay < 0)
                next_state = DONE;
            else
                next_state = COUNT;
        end

        DONE: begin
            // Wait for ack to return to IDLE and start new search
            if (ack)
                next_state = IDLE;
            else
                next_state = DONE;
        end

        default: next_state = IDLE;
    endcase
end

// On entering COUNT state, initialize counting registers with delay
always @(posedge clk) begin
    if (reset == 0) begin
        if (state != COUNT && next_state == COUNT) begin
            // Initialize counting phase
            remaining_delay <= {1'b0, delay_reg}; // sign bit 0, 4 bits delay
            cycle_count_1000 <= 10'd0;
            count <= delay_reg;
        end
    end
end

endmodule