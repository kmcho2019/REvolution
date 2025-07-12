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
    localparam IDLE        = 2'b00;
    localparam SHIFT_DELAY = 2'b01;
    localparam COUNTING    = 2'b10;
    localparam DONE        = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;  // Shift register for 1101 pattern detection
    reg [3:0] delay_reg;    // Shift register for delay value
    reg [2:0] bit_count;    // Counts 0-3 for delay bits
    reg [3:0] delay_value;  // Stored delay value
    reg [9:0] cycle_count;  // Counts 0-999 (1000 cycles)
    reg [3:0] count_value;  // Current countdown value

    // Pattern detection and FSM transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            bit_count <= 3'b0;
            delay_reg <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift in data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                SHIFT_DELAY: begin
                    if (bit_count < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_count <= bit_count + 1;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT_DELAY;
                else
                    next_state = IDLE;
            end

            SHIFT_DELAY: begin
                if (bit_count == 4)
                    next_state = COUNTING;
                else
                    next_state = SHIFT_DELAY;
            end

            COUNTING: begin
                if (count_value == 0 && cycle_count == 999)
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

    // Countdown logic
    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 10'b0;
            count_value <= 4'b0;
            delay_value <= 4'b0;
            count <= 4'b0;
        end else begin
            case (state)
                SHIFT_DELAY: begin
                    if (bit_count == 4) begin
                        delay_value <= delay_reg;
                        count_value <= delay_reg;
                    end
                    cycle_count <= 10'b0;
                end

                COUNTING: begin
                    if (cycle_count == 999) begin
                        cycle_count <= 10'b0;
                        if (count_value != 0)
                            count_value <= count_value - 1;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                    count <= count_value;
                end

                DONE: begin
                    count <= 4'b0;  // Don't care value when not counting
                end

                default: begin
                    count <= 4'b0;  // Don't care value when not counting
                end
            endcase
        end
    end

endmodule