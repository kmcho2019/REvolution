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
    reg [1:0] bit_count;    // Counts 0-3 for delay bits (2 bits sufficient)
    reg [3:0] delay_value;  // Stored delay value
    reg [9:0] cycle_count;  // Counts 0-999 (1000 cycles)
    reg [3:0] count_value;  // Current countdown value

    // FSM state transition and pattern detection
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            bit_count <= 2'b0;
            delay_reg <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
            cycle_count <= 10'b0;
            delay_value <= 4'b0;
            count_value <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;  // Don't care value
                end

                SHIFT_DELAY: begin
                    if (bit_count < 3) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_count <= bit_count + 1;
                    end else if (bit_count == 3) begin
                        delay_reg <= {delay_reg[2:0], data};
                        delay_value <= {delay_reg[2:0], data};
                        count_value <= {delay_reg[2:0], data};
                        bit_count <= bit_count + 1;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;  // Don't care value
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    
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
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;  // Don't care value
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (pattern_reg == 4'b1101) ? SHIFT_DELAY : IDLE;
            end

            SHIFT_DELAY: begin
                next_state = (bit_count == 4) ? COUNTING : SHIFT_DELAY;
            end

            COUNTING: begin
                next_state = (count_value == 0 && cycle_count == 999) ? DONE : COUNTING;
            end

            DONE: begin
                next_state = ack ? IDLE : DONE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule