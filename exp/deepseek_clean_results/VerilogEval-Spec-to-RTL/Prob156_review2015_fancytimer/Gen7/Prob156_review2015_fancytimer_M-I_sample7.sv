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
        GET_DELAY,
        COUNT,
        DONE
    } state_t;

    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [9:0] cycle_counter;  // Counts 0-999 (1000 cycles)
    reg [3:0] delay_counter;  // Counts delay down to 0
    state_t state;
    reg [1:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            cycle_counter <= 0;
            delay_counter <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                    count <= 4'b0;
                    
                    // Detect 1101 pattern
                    if (shift_reg == 4'b1101) begin
                        state <= GET_DELAY;
                        bit_count <= 0;
                    end
                end

                GET_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == 3) begin
                        delay <= shift_reg;
                        delay_counter <= shift_reg;
                        cycle_counter <= 0;
                        state <= COUNT;
                        counting <= 1;
                        count <= shift_reg;
                    end
                end

                COUNT: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_counter == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            delay_counter <= delay_counter - 1;
                            count <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 4'b0;
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule