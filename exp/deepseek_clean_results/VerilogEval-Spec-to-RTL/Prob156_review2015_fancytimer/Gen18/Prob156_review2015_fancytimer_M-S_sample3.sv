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
        CAPTURE_DELAY,
        COUNT,
        DONE
    } state_t;

    reg [1:0] state, next_state;
    reg [3:0] shift_reg;
    reg [2:0] bit_cnt;
    reg [15:0] main_counter;
    reg [9:0] phase_counter;
    reg [3:0] delay_val;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            bit_cnt <= 3'b0;
            main_counter <= 16'b0;
            phase_counter <= 10'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                        bit_cnt <= 3'b0;
                    end
                end

                CAPTURE_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 3'd3) begin
                        delay_val <= shift_reg;
                        state <= COUNT;
                        main_counter <= 16'b0;
                        phase_counter <= 10'b0;
                        counting <= 1'b1;
                    end
                end

                COUNT: begin
                    if (phase_counter == 10'd999) begin
                        phase_counter <= 10'b0;
                        if (main_counter == (delay_val + 1) * 16'd1000 - 1) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            main_counter <= main_counter + 1;
                        end
                    end else begin
                        phase_counter <= phase_counter + 1;
                        main_counter <= main_counter + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Count output
    always @(*) begin
        if (state == COUNT) begin
            count = delay_val - (main_counter / 16'd1000);
        end else begin
            count = 4'b0; // Don't-care when not counting
        end
    end

endmodule