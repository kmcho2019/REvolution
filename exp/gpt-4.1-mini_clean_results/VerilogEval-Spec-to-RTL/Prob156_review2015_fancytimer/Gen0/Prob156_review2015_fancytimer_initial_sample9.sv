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
localparam SEARCH     = 2'd0;
localparam LOAD_DELAY = 2'd1;
localparam COUNT      = 2'd2;
localparam DONE       = 2'd3;

reg [1:0] state, next_state;

// Shift register to detect pattern 1101
reg [3:0] pattern_shift;

// Delay register (4 bits)
reg [3:0] delay_reg;

// Counter for 1000 cycles per delay step
reg [9:0] cycle_count; // counts 0..999

// Remaining delay counter (counts from delay down to 0)
reg [3:0] remaining_delay;

// Synchronize all sequential logic on posedge clk
always @(posedge clk) begin
    if (reset) begin
        // Reset all
        state <= SEARCH;
        pattern_shift <= 4'b0000;
        delay_reg <= 4'b0000;
        cycle_count <= 10'd0;
        remaining_delay <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0000;
    end else begin
        state <= next_state;

        case(state)
            SEARCH: begin
                // Shift in data bit
                pattern_shift <= {pattern_shift[2:0], data};
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
                cycle_count <= 10'd0;
                delay_reg <= delay_reg; // hold
                remaining_delay <= remaining_delay; // hold
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first: on each clock shift in data into delay_reg[3:0]
                // We can implement a 4-bit shift register shifting left to right or right to left
                // According to spec: MSB first
                // So first bit shifted in goes to delay_reg[3], then next to delay_reg[2], etc.
                delay_reg <= {delay_reg[2:0], data};
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
                cycle_count <= 10'd0;
                remaining_delay <= remaining_delay; // hold
                pattern_shift <= pattern_shift; // hold
            end

            COUNT: begin
                counting <= 1'b1;
                done <= 1'b0;
                pattern_shift <= pattern_shift; // hold
                delay_reg <= delay_reg; // hold

                if (cycle_count == 10'd999) begin
                    cycle_count <= 10'd0;
                    if (remaining_delay != 4'd0) begin
                        remaining_delay <= remaining_delay - 1'b1;
                    end
                end else begin
                    cycle_count <= cycle_count + 1'b1;
                    remaining_delay <= remaining_delay; // hold
                end

                count <= remaining_delay;
            end

            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                pattern_shift <= pattern_shift; // hold
                delay_reg <= delay_reg; // hold
                cycle_count <= 10'd0;
                remaining_delay <= remaining_delay; // hold
                count <= 4'b0000;
            end

            default: begin
                // Should not happen
                state <= SEARCH;
                counting <= 1'b0;
                done <= 1'b0;
                pattern_shift <= 4'b0000;
                delay_reg <= 4'b0000;
                cycle_count <= 10'd0;
                remaining_delay <= 4'd0;
                count <= 4'b0000;
            end
        endcase
    end
end

// State transition logic
always @(*) begin
    next_state = state;
    case(state)
        SEARCH: begin
            // When pattern_shift == 4'b1101 (binary 13 decimal) go to LOAD_DELAY
            if (pattern_shift == 4'b1101)
                next_state = LOAD_DELAY;
            else
                next_state = SEARCH;
        end

        LOAD_DELAY: begin
            // After 4 delay bits have been shifted in, move to COUNT
            // We shift delay_reg 4 times on 4 clock cycles
            // So count how many bits have been shifted in?
            // To do that, count how many bits we have shifted in in LOAD_DELAY state
            // Let's add a counter to count bits shifted in LOAD_DELAY state

            // We'll implement a separate load_bit_count register updated only in LOAD_DELAY state
            // This is combinational, so implement load_bit_count as reg

            // But since in combinational always @(*) we can't access state reg, implement next_state logic based on load_bit_count.

            // So rewrite this part below after implementing load_bit_count.
        end

        COUNT: begin
            // When counting finishes (remaining_delay == 0 and cycle_count == 999), go to DONE
            if ((remaining_delay == 4'd0) && (cycle_count == 10'd999))
                next_state = DONE;
            else
                next_state = COUNT;
        end

        DONE: begin
            // Wait for ack == 1 then go to SEARCH
            if (ack)
                next_state = SEARCH;
            else
                next_state = DONE;
        end

        default: next_state = SEARCH;
    endcase
end

// Add load_bit_count to track how many delay bits have been shifted in LOAD_DELAY
reg [2:0] load_bit_count; // counts 0 to 4

always @(posedge clk) begin
    if (reset) begin
        load_bit_count <= 3'd0;
    end else begin
        if (state == LOAD_DELAY) begin
            load_bit_count <= load_bit_count + 1'b1;
        end else begin
            load_bit_count <= 3'd0;
        end
    end
end

// Now finalize next_state logic for LOAD_DELAY:
always @(*) begin
    if (state == LOAD_DELAY) begin
        if (load_bit_count == 3'd4)
            next_state = COUNT;
        else
            next_state = LOAD_DELAY;
    end
end

// Initialize remaining_delay and count at transition from LOAD_DELAY to COUNT
always @(posedge clk) begin
    if (reset) begin
        remaining_delay <= 4'd0;
        count <= 4'd0;
    end else begin
        if (state == LOAD_DELAY && load_bit_count == 3'd4) begin
            // Start counting
            remaining_delay <= delay_reg;
            count <= delay_reg;
            cycle_count <= 10'd0;
        end
    end
end

endmodule