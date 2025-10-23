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
    localparam IDLE        = 2'b00;
    localparam CAPTURE     = 2'b01;
    localparam COUNTING    = 2'b10;
    localparam WAIT_ACK    = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [13:0] cycle_counter;  // Can count up to 16383 cycles
    reg [2:0] capture_count;

    // Pattern detection
    wire pattern_match = (pattern_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            cycle_counter <= 14'b0;
            capture_count <= 3'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            // Shift register for pattern detection
            pattern_reg <= {pattern_reg[2:0], data};

            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (pattern_match) begin
                        state <= CAPTURE;
                        capture_count <= 3'b0;
                    end
                end

                CAPTURE: begin
                    // Capture next 4 bits as delay value
                    delay_val <= {delay_val[2:0], data};
                    capture_count <= capture_count + 1;

                    if (capture_count == 3'b11) begin
                        state <= COUNTING;
                        counting <= 1'b1;
                        // Initialize counter: (delay_val + 1) * 1000
                        cycle_counter <= (delay_val + 1) * 14'd1000 - 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 14'b0) begin
                        state <= WAIT_ACK;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
                    end

                    // Update count output (remaining 1000-cycle periods)
                    count <= (cycle_counter + 999) / 1000;
                end

                WAIT_ACK: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule