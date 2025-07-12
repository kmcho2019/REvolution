module TopModule (
    input        clk,
    input        reset,
    input        in,
    output reg   done
);
    // Parameter: number of clk cycles per bit period (adjust as needed)
    // For simulation/demo purposes, we set BIT_PERIOD to 4.
    // In real hardware, this would match baud rate timing.
    parameter BIT_PERIOD = 4;

    // FSM states
    localparam [1:0]
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11;

    reg [1:0] state, next_state;

    // bit timer counter: counts clocks within a bit period
    reg [$clog2(BIT_PERIOD)-1:0] bit_timer;

    // bit count: counts bits received (0 to 7 for data bits)
    reg [2:0] bit_count;

    // shift register to store received bits
    reg [7:0] data_shift;

    // flag to sample bit at bit boundary (when bit_timer == BIT_PERIOD-1)
    wire sample_tick = (bit_timer == BIT_PERIOD - 1);

    // Sequential logic: FSM and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_timer <= 0;
            bit_count <= 0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // done pulse is one cycle only by default

            case (state)
                IDLE: begin
                    bit_timer <= 0;
                    bit_count <= 0;
                    data_shift <= 8'd0;

                    if (in == 1'b0) begin
                        // Detected start bit line low, go to START to confirm
                        state <= START;
                        bit_timer <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end

                START: begin
                    // Increment bit_timer, wait half bit period to confirm start bit
                    bit_timer <= bit_timer + 1;
                    if (bit_timer == (BIT_PERIOD/2 - 1)) begin
                        // Sample the line at middle of start bit
                        if (in == 1'b0) begin
                            // Confirmed start bit valid, move to DATA state
                            state <= DATA;
                            bit_timer <= 0;
                            bit_count <= 0;
                            data_shift <= 8'd0;
                        end else begin
                            // False start, line went back high, return to IDLE
                            state <= IDLE;
                            bit_timer <= 0;
                        end
                    end
                end

                DATA: begin
                    bit_timer <= bit_timer + 1;

                    if (sample_tick) begin
                        // Sample data bit at bit boundary
                        // Shift new bit into LSB (LSB first), shift left
                        data_shift <= {in, data_shift[7:1]};
                        bit_count <= bit_count + 1;
                        bit_timer <= 0;

                        if (bit_count == 3'd7) begin
                            // After last data bit, go to STOP
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    bit_timer <= bit_timer + 1;

                    if (sample_tick) begin
                        bit_timer <= 0;
                        if (in == 1'b1) begin
                            // Valid stop bit, signal done and return to IDLE
                            done <= 1'b1;
                            state <= IDLE;
                        end else begin
                            // Invalid stop bit, stay here until valid stop bit received
                            state <= STOP;
                        end
                    end
                end

                default: begin
                    state <= IDLE;
                    bit_timer <= 0;
                    bit_count <= 0;
                    data_shift <= 8'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule