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
    reg [3:0] pattern_reg;  // Shift register for 1101 pattern
    reg [3:0] delay_reg;    // Stores the delay value
    reg [2:0] shift_count;  // Counts 4 bits for delay
    reg [13:0] timer;       // 14-bit counter for up to 16000 cycles (1000*(15+1))
    reg [9:0] cycle_count;  // Counts 1000 cycles per delay step
    reg [3:0] count_down;   // Current count value to output

    // Pattern detection and FSM transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 3'b0;
            delay_reg <= 4'b0;
            timer <= 14'b0;
            cycle_count <= 10'b0;
            count_down <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                SHIFT_DELAY: begin
                    if (shift_count < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        shift_count <= shift_count + 1;
                    end
                end

                COUNTING: begin
                    if (cycle_count == 999) begin
                        cycle_count <= 0;
                        count_down <= count_down - 1;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end

                    if (timer == (delay_reg + 1) * 1000 - 1) begin
                        timer <= 0;
                    end else begin
                        timer <= timer + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        pattern_reg <= 4'b0;
                        shift_count <= 0;
                        delay_reg <= 4'b0;
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
                if (shift_count == 4) begin
                    next_state = COUNTING;
                    counting <= 1'b1;
                    count_down <= delay_reg;
                end
            end

            COUNTING: begin
                if (timer == (delay_reg + 1) * 1000 - 1) begin
                    next_state = DONE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end

            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end

    // Output count value during COUNTING state
    always @(*) begin
        if (state == COUNTING) begin
            count = count_down;
        end else begin
            count = 4'b0;  // Don't care when not counting
        end
    end

endmodule