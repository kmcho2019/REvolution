module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    typedef enum {
        IDLE,
        PATTERN_DETECT,
        CAPTURE_DELAY,
        COUNTING,
        DONE
    } state_t;

    state_t state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [1:0] bit_counter;
    reg [15:0] cycle_counter;  // Enough for (15+1)*1000 = 16000 cycles
    reg [3:0] current_delay;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 2'b0;
            cycle_counter <= 0;
            current_delay <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= PATTERN_DETECT;
                    end
                    counting <= 0;
                    done <= 0;
                end

                PATTERN_DETECT: begin
                    state <= CAPTURE_DELAY;
                    bit_counter <= 2'b0;
                    delay_reg <= 4'b0;
                end

                CAPTURE_DELAY: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 2'b11) begin
                        current_delay <= delay_reg;
                        cycle_counter <= (delay_reg + 1) * 1000 - 1;
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    counting <= 1;
                    if (cycle_counter == 0) begin
                        state <= DONE;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
                    end
                    // Update count every 1000 cycles
                    count <= (cycle_counter / 1000);
                end

                DONE: begin
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule