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
    reg [3:0] delay_value;  // Captured delay value
    reg [9:0] cycle_counter; // Counts up to 1000 cycles
    reg [3:0] period_counter; // Counts remaining periods

    // Pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                end

                READ_DELAY: begin
                    if (cycle_counter < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 999) begin
                        period_counter <= period_counter - 1;
                        cycle_counter <= 0;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= period_counter;
                end

                DONE: begin
                    if (ack) begin
                        done <= 0;
                    end else begin
                        done <= 1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (pattern_reg == 4'b1101) ? READ_DELAY : IDLE;
            end

            READ_DELAY: begin
                next_state = (cycle_counter == 3) ? COUNTING : READ_DELAY;
            end

            COUNTING: begin
                next_state = (period_counter == 0 && cycle_counter == 999) ? DONE : COUNTING;
            end

            DONE: begin
                next_state = (ack) ? IDLE : DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Cycle counter and delay capture logic
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 0;
            delay_reg <= 0;
            delay_value <= 0;
            period_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    cycle_counter <= 0;
                end

                READ_DELAY: begin
                    if (cycle_counter < 4) begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    if (cycle_counter == 3) begin
                        delay_value <= delay_reg;
                        period_counter <= delay_reg;
                    end
                end

                COUNTING: begin
                    counting <= 1;
                    if (cycle_counter == 999) begin
                        if (period_counter == 0) begin
                            counting <= 0;
                        end
                    end
                end

                DONE: begin
                    counting <= 0;
                end
            endcase
        end
    end
endmodule