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
    reg [3:0] pattern_reg;  // For detecting 1101
    reg [3:0] delay;        // Stored delay value
    reg [3:0] delay_count;  // Current count value
    reg [9:0] cycle_count;  // Counts 0-999 for each delay step

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Main FSM
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            delay <= 4'b0;
            delay_count <= 4'b0;
            cycle_count <= 10'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                end

                READ_DELAY: begin
                    if (cycle_count < 3) begin
                        delay <= {delay[2:0], data};
                        cycle_count <= cycle_count + 1;
                    end else begin
                        delay <= {delay[2:0], data};  // Final bit
                        delay_count <= {delay[2:0], data};
                        cycle_count <= 0;
                    end
                end

                COUNTING: begin
                    counting <= 1;
                    if (cycle_count == 999) begin
                        cycle_count <= 0;
                        if (delay_count == 0) begin
                            // Counting complete
                            counting <= 0;
                        end else begin
                            delay_count <= delay_count - 1;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                    count <= delay_count;
                end

                DONE: begin
                    done <= 1;
                    if (ack) begin
                        done <= 0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = READ_DELAY;
                end else begin
                    next_state = IDLE;
                end
            end

            READ_DELAY: begin
                if (cycle_count == 3) begin
                    next_state = COUNTING;
                end else begin
                    next_state = READ_DELAY;
                end
            end

            COUNTING: begin
                if (delay_count == 0 && cycle_count == 999) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNTING;
                end
            end

            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule