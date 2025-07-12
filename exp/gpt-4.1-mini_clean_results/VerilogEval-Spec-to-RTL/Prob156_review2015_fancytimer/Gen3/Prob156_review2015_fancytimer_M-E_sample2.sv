module TopModule (
    input  wire       clk,
    input  wire       reset,    // synchronous active high reset
    input  wire       data,     // serial data input
    output reg  [3:0] count,    // remaining time blocks output
    output reg        counting, // high while counting
    output reg        done,     // high when timer expired, waiting for ack
    input  wire       ack       // acknowledge input
);

// States encoding
localparam IDLE       = 2'd0;
localparam DELAY_LOAD = 2'd1;
localparam COUNTING   = 2'd2;
localparam WAIT_ACK   = 2'd3;

reg [1:0] state, next_state;

// Shift register for detecting pattern 1101 in IDLE state
reg [3:0] pattern_reg;

// Delay register - stores 4 bits of delay (MSB first)
reg [3:0] delay_reg;
reg [2:0] delay_bits_loaded; // counts from 0 to 4 in DELAY_LOAD

// Micro counter counts from 0 to 999 for each 1000-cycle block
reg [9:0] micro_counter; // 10 bits enough for 0-999

// Block counter counts how many 1000-cycle blocks elapsed, from 0 to delay+1
reg [4:0] block_counter; // 5 bits to cover delay+1 up to 17 max

// Sequential state register and main logic
always @(posedge clk) begin
    if (reset) begin
        state            <= IDLE;
        pattern_reg      <= 4'b0;
        delay_reg        <= 4'b0;
        delay_bits_loaded <= 3'd0;
        micro_counter    <= 10'd0;
        block_counter    <= 5'd0;
        count            <= 4'd0;
        counting         <= 1'b0;
        done             <= 1'b0;
    end else begin
        state <= next_state;

        case(state)
            IDLE: begin
                // Shift pattern register left, append data bit (serial in)
                pattern_reg <= {pattern_reg[2:0], data};
                // Reset delay loading counters and others
                delay_bits_loaded <= 3'd0;
                delay_reg <= delay_reg; // hold previous delay_reg
                micro_counter <= 10'd0;
                block_counter <= 5'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0;
            end

            DELAY_LOAD: begin
                // Shift delay_reg left, append data bit (MSB first)
                delay_reg <= {delay_reg[2:0], data};
                delay_bits_loaded <= delay_bits_loaded + 1'b1;
                pattern_reg <= pattern_reg; // hold pattern
                micro_counter <= 10'd0;
                block_counter <= 5'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0;
            end

            COUNTING: begin
                pattern_reg <= pattern_reg;
                delay_bits_loaded <= delay_bits_loaded;
                counting <= 1'b1;
                done <= 1'b0;

                // Micro counter counts cycles 0..999
                if (micro_counter == 10'd999) begin
                    micro_counter <= 10'd0;
                    // Increment block_counter to count completed 1000-cycle blocks
                    if (block_counter < (delay_reg + 1))
                        block_counter <= block_counter + 1'b1;
                end else begin
                    micro_counter <= micro_counter + 1'b1;
                    block_counter <= block_counter;
                end

                // count output = remaining blocks = (delay+1) - block_counter
                // Clamp count to zero minimum
                if (block_counter <= (delay_reg + 1))
                    count <= (delay_reg + 1) - block_counter;
                else
                    count <= 4'd0;

            end

            WAIT_ACK: begin
                // wait here until ack asserted
                counting <= 1'b0;
                done <= 1'b1;
                // count don't care - drive zero for convenience
                count <= 4'd0;
                pattern_reg <= pattern_reg;
                delay_reg <= delay_reg;
                delay_bits_loaded <= delay_bits_loaded;
                micro_counter <= 10'd0;
                block_counter <= 5'd0;
            end

            default: begin
                state <= IDLE;
                pattern_reg <= 4'b0;
                delay_reg <= 4'b0;
                delay_bits_loaded <= 3'd0;
                micro_counter <= 10'd0;
                block_counter <= 5'd0;
                count <= 4'd0;
                counting <= 1'b0;
                done <= 1'b0;
            end
        endcase
    end
end

// Next state combinational logic
always @(*) begin
    next_state = state;

    case(state)
        IDLE: begin
            // Detect start pattern 1101 in pattern_reg
            if (pattern_reg == 4'b1101)
                next_state = DELAY_LOAD;
            else
                next_state = IDLE;
        end

        DELAY_LOAD: begin
            // After 4 bits delay loaded, start counting
            if (delay_bits_loaded == 3'd4)
                next_state = COUNTING;
            else
                next_state = DELAY_LOAD;
        end

        COUNTING: begin
            // When block_counter reached delay+1 and micro_counter at 999 (end of last 1000 cycle block), done counting
            if ((block_counter == (delay_reg + 1)) && (micro_counter == 10'd999))
                next_state = WAIT_ACK;
            else
                next_state = COUNTING;
        end

        WAIT_ACK: begin
            // Wait until ack is high, then back to IDLE to search again
            if (ack)
                next_state = IDLE;
            else
                next_state = WAIT_ACK;
        end

        default: next_state = IDLE;
    endcase
end

endmodule