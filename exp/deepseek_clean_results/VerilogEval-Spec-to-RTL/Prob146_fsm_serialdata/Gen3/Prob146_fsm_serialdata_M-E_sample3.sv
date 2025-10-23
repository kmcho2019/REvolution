module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    typedef enum {IDLE, START, DATA, STOP} state_t;
    reg [1:0] state, next_state;

    // Sampling control
    reg [3:0] timer;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg sample_now;

    // Edge detection
    reg in_prev;
    wire falling_edge = in_prev & ~in;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            timer <= 0;
            bit_count <= 0;
            data_reg <= 0;
            out_byte <= 0;
            done <= 0;
            in_prev <= 1;
        end else begin
            in_prev <= in;
            done <= 0;  // Default to not done

            case (state)
                IDLE: begin
                    timer <= 0;
                    bit_count <= 0;
                    if (falling_edge) begin
                        state <= START;
                        timer <= 1;
                    end
                end

                START: begin
                    if (timer == 8) begin
                        // Sample start bit at midpoint
                        if (~in) begin
                            state <= DATA;
                            timer <= 1;
                        end else begin
                            state <= IDLE;  // Invalid start bit
                        end
                    end else begin
                        timer <= timer + 1;
                    end
                end

                DATA: begin
                    if (timer == 8) begin
                        // Sample data bit at midpoint
                        data_reg <= {in, data_reg[7:1]};  // LSB first
                        timer <= 1;
                        if (bit_count == 7) begin
                            state <= STOP;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        timer <= timer + 1;
                    end
                end

                STOP: begin
                    if (timer == 8) begin
                        // Sample stop bit at midpoint
                        if (in) begin
                            out_byte <= data_reg;
                            done <= 1;
                        end
                        state <= IDLE;
                    end else begin
                        timer <= timer + 1;
                    end
                end
            endcase
        end
    end

endmodule