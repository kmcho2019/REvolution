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
    localparam SHIFT_DELAY = 2'b01;
    localparam COUNTING   = 2'b10;
    localparam DONE       = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;  // For detecting 1101
    reg [3:0] delay_reg;    // For storing delay value
    reg [3:0] delay_counter; // Current delay value being counted
    reg [9:0] cycle_counter; // Counts 0-999 (1000 cycles)
    reg [2:0] shift_count;   // Counts 0-3 for shifting delay bits

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            delay_counter <= 4'b0;
            cycle_counter <= 10'b0;
            shift_count <= 3'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift in data to detect pattern
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                SHIFT_DELAY: begin
                    if (shift_count < 3) begin
                        shift_count <= shift_count + 1;
                        delay_reg <= {delay_reg[2:0], data};
                    end else begin
                        delay_reg <= {delay_reg[2:0], data}; // Final bit
                        delay_counter <= {delay_reg[2:0], data};
                        shift_count <= 0;
                    end
                end

                COUNTING: begin
                    counting <= 1'b1;
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (delay_counter == 4'b0) begin
                            // Counting complete
                            counting <= 1'b0;
                        end else begin
                            delay_counter <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= delay_counter;
                end

                DONE: begin
                    done <= 1'b1;
                    if (ack) begin
                        done <= 1'b0;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT_DELAY;
                end
            end

            SHIFT_DELAY: begin
                if (shift_count == 3) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                if (cycle_counter == 10'd999 && delay_counter == 4'b0) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule