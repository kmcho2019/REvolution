module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // Pattern detection registers
    reg [3:0] data_history;
    wire pattern_match = (data_history == 4'b1101);

    // State machine
    typedef enum {IDLE, CAPTURE, RUN, FINISH} state_t;
    reg [1:0] state;

    // Timing registers
    reg [15:0] total_cycles;
    reg [15:0] cycle_counter;
    reg [3:0] bits_captured;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_history <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            // Update data history for pattern detection
            data_history <= {data_history[2:0], data};

            case (state)
                IDLE: begin
                    if (pattern_match) begin
                        state <= CAPTURE;
                        bits_captured <= 0;
                    end
                    done <= 0;
                    counting <= 0;
                end

                CAPTURE: begin
                    if (bits_captured == 4) begin
                        // Calculate (delay+1)*1000
                        total_cycles <= (data_history + 1) * 1000;
                        cycle_counter <= 0;
                        state <= RUN;
                        counting <= 1;
                    end else begin
                        bits_captured <= bits_captured + 1;
                    end
                end

                RUN: begin
                    if (cycle_counter == total_cycles - 1) begin
                        state <= FINISH;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    // Update count output (remaining chunks)
                    count <= (total_cycles - cycle_counter - 1) / 1000;
                end

                FINISH: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule