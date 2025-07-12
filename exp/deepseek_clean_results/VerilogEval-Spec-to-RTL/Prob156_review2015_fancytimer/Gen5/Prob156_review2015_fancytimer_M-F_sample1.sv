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
        PATTERN_COLLECT,
        CAPTURE_DELAY,
        COUNTING,
        DONE
    } state_t;

    state_t state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [2:0] bit_counter;  // Now 3 bits to count up to 4
    reg [15:0] cycle_counter;
    reg [15:0] total_cycles;
    reg [9:0] sub_counter;  // Counts 0-999 for each delay step

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 0;
            cycle_counter <= 0;
            total_cycles <= 0;
            sub_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3) begin
                        state <= PATTERN_COLLECT;
                        bit_counter <= 0;
                    end
                    counting <= 0;
                    done <= 0;
                end

                PATTERN_COLLECT: begin
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                    end else begin
                        state <= IDLE;
                    end
                    bit_counter <= 0;
                end

                CAPTURE_DELAY: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3) begin
                        total_cycles <= (delay_reg + 1) * 1000;
                        cycle_counter <= (delay_reg + 1) * 1000 - 1;
                        sub_counter <= 0;
                        count <= delay_reg;
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    counting <= 1;
                    if (cycle_counter == 0) begin
                        state <= DONE;
                        counting <= 0;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
                        sub_counter <= sub_counter + 1;
                        if (sub_counter == 999) begin
                            count <= count - 1;
                            sub_counter <= 0;
                        end
                    end
                end

                DONE: begin
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                        bit_counter <= 0;
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule