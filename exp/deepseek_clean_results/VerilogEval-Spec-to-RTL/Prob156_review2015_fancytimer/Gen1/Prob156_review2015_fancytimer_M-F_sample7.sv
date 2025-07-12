module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam IDLE       = 2'b00;
    localparam READ_DELAY = 2'b01;
    localparam COUNTING   = 2'b10;
    localparam DONE       = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;  // Shift register for pattern detection
    reg [3:0] delay_reg;    // Shift register for delay value
    reg [2:0] delay_bits_read; // Count of delay bits read
    reg [9:0] cycle_counter; // Counts up to 1000 cycles (0-999)
    reg [3:0] delay_counter; // Counts down the delay value

    // State transition and pattern detection
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_read <= 3'b0;
            cycle_counter <= 10'b0;
            delay_counter <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    done <= 1'b0;
                end

                READ_DELAY: begin
                    if (delay_bits_read < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        delay_bits_read <= delay_bits_read + 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (delay_counter != 0) begin
                            delay_counter <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= delay_counter;
                end

                DONE: begin
                    if (ack) begin
                        pattern_reg <= 4'b0;
                        delay_reg <= 4'b0;
                        delay_bits_read <= 3'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = READ_DELAY;
                end
            end

            READ_DELAY: begin
                if (delay_bits_read == 4) begin
                    next_state = COUNTING;
                    counting = 1'b1;
                end
            end

            COUNTING: begin
                counting = 1'b1;
                if (cycle_counter == 10'd999 && delay_counter == 4'b0) begin
                    next_state = DONE;
                    counting = 1'b0;
                    done = 1'b1;
                end
            end

            DONE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Initialize counters when entering COUNTING state
    always @(posedge clk) begin
        if (state == READ_DELAY && next_state == COUNTING) begin
            delay_counter <= delay_reg;
            cycle_counter <= 10'b0;
        end
    end

endmodule