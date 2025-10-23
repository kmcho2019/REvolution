module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire       data,
    output reg  [3:0] count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

// FSM states
typedef enum reg [1:0] {
    SEARCH     = 2'd0,
    LOAD_DELAY = 2'd1,
    COUNT      = 2'd2,
    DONE       = 2'd3
} state_t;

state_t state, next_state;

// Shift register to detect start pattern "1101"
reg [3:0] pattern_shift;

// Delay register (4 bits)
reg [3:0] delay_reg;

// Counter for number of loaded delay bits (0 to 3)
reg [1:0] load_bit_count;

// ms_count counts clock cycles 0..999
reg [9:0] ms_count;

// delay_count counts down delay blocks from delay_reg to 0
reg [3:0] delay_count;

// Sequential FSM and counters
always @(posedge clk) begin
    if (reset) begin
        state          <= SEARCH;
        pattern_shift  <= 4'b0000;
        delay_reg      <= 4'b0000;
        load_bit_count <= 2'd0;
        ms_count       <= 10'd0;
        delay_count    <= 4'd0;
        counting      <= 1'b0;
        done          <= 1'b0;
        count         <= 4'bxxxx;
    end else begin
        state <= next_state;

        case (state)
            SEARCH: begin
                // Shift in data at LSB (pattern MSB first)
                pattern_shift <= {pattern_shift[2:0], data};

                // Clear outputs and counters
                counting      <= 1'b0;
                done          <= 1'b0;
                count         <= 4'bxxxx;  // don't care
                load_bit_count <= 2'd0;
                ms_count       <= 10'd0;
                delay_count    <= 4'd0;
                // delay_reg holds previous value until LOAD_DELAY updates
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first: shift left and add new bit at LSB
                delay_reg <= {delay_reg[2:0], data};

                load_bit_count <= load_bit_count + 1'b1;

                counting <= 1'b0;
                done     <= 1'b0;
                count    <= 4'bxxxx;
                ms_count <= 10'd0;
                delay_count <= 4'd0;
                // pattern_shift holds unchanged
            end

            COUNT: begin
                counting <= 1'b1;
                done <= 1'b0;

                // ms_count increments 0..999
                if (ms_count == 10'd999) begin
                    ms_count <= 10'd0;

                    // Delay blocks count down after every 1000 cycles
                    if (delay_count != 0) begin
                        delay_count <= delay_count - 1'b1;
                    end
                    // else delay_count == 0 stays 0 until state changes
                end else begin
                    ms_count <= ms_count + 1'b1;
                end

                count <= delay_count;  // output remaining delay blocks
            end

            DONE: begin
                counting <= 1'b0;
                done     <= 1'b1;
                count    <= 4'bxxxx;
                // reset counters, hold delay_reg and pattern_shift unchanged
                ms_count <= 10'd0;
                delay_count <= 4'd0;
                load_bit_count <= 2'd0;
            end

            default: begin
                // Safety fallback
                state          <= SEARCH;
                pattern_shift  <= 4'b0000;
                delay_reg      <= 4'b0000;
                load_bit_count <= 2'd0;
                ms_count       <= 10'd0;
                delay_count    <= 4'd0;
                counting      <= 1'b0;
                done          <= 1'b0;
                count         <= 4'bxxxx;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;

    case (state)
        SEARCH: begin
            if (pattern_shift == 4'b1101)
                next_state = LOAD_DELAY;
            else
                next_state = SEARCH;
        end

        LOAD_DELAY: begin
            if (load_bit_count == 2'd4)
                next_state = COUNT;
            else
                next_state = LOAD_DELAY;
        end

        COUNT: begin
            // Transition to DONE when delay_count == 0 and ms_count == 999 (last cycle of last block)
            if ((delay_count == 0) && (ms_count == 10'd999))
                next_state = DONE;
            else
                next_state = COUNT;
        end

        DONE: begin
            // Wait for ack to return to SEARCH
            if (ack)
                next_state = SEARCH;
            else
                next_state = DONE;
        end

        default: next_state = SEARCH;
    endcase
end

// Initialize delay_count when entering COUNT state
always @(posedge clk) begin
    if (reset) begin
        delay_count <= 4'd0;
        ms_count <= 10'd0;
    end else begin
        if ((state != COUNT) && (next_state == COUNT)) begin
            // load delay_count with delay_reg value
            delay_count <= delay_reg;
            ms_count    <= 10'd0;
        end
    end
end

endmodule