module TopModule(
    input           clk,
    input           reset,
    input           data,
    output [3:0]    count,
    output          counting,
    output          done,
    input           ack
);

    // Define the states
    typedef enum logic [2:0] {
        IDLE,
        SHIFT,
        COUNTING,
        DONE_STATE
    } state_t;

    state_t current_state, next_state;

    // Define the shift register
    logic [3:0] delay;

    // Define the counter
    logic [15:0] counter;

    // Define the remaining time
    logic [3:0] remaining_time;

    // Define the pattern detection logic
    logic [3:0] pattern;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pattern <= 4'b0000;
            delay <= 4'b0000;
            counter <= 16'b0000000000000000;
            remaining_time <= 4'b0000;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (data == 1'b1) begin
                        pattern <= {pattern[2:0], 1'b1};
                    end else begin
                        pattern <= {pattern[2:0], 1'b0};
                    end
                    if (pattern == 4'b1101) begin
                        pattern <= 4'b0000;
                        next_state <= SHIFT;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                SHIFT: begin
                    delay <= {data, delay[3:1]};
                    if (delay[0] == 1'b1) begin
                        next_state <= COUNTING;
                    end else begin
                        next_state <= SHIFT;
                    end
                end
                COUNTING: begin
                    if (counter == (delay + 1) * 1000 - 1) begin
                        next_state <= DONE_STATE;
                    end else begin
                        counter <= counter + 1;
                        if (counter % 1000 == 0) begin
                            remaining_time <= remaining_time - 1;
                        end
                        next_state <= COUNTING;
                    end
                end
                DONE_STATE: begin
                    if (ack == 1'b1) begin
                        next_state <= IDLE;
                    end else begin
                        next_state <= DONE_STATE;
                    end
                end
                default: next_state <= IDLE;
            endcase
        end
    end

    always_comb begin
        counting = (current_state == COUNTING);
        done = (current_state == DONE_STATE);
        count = (current_state == COUNTING) ? remaining_time : 4'bxxxx;
        if (current_state == IDLE) begin
            remaining_time = 4'bxxxx;
        end else if (current_state == SHIFT) begin
            remaining_time = 4'bxxxx;
        end else if (current_state == COUNTING) begin
            remaining_time = delay - (counter / 1000);
        end else if (current_state == DONE_STATE) begin
            remaining_time = 4'b0000;
        end
    end

endmodule