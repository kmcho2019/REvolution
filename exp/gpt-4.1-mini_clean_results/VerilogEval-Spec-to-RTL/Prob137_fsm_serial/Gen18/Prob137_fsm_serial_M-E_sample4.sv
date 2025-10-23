module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE       = 2'b00,
        START      = 2'b01,
        DATA       = 2'b10,
        STOP_CHECK = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;
    reg in_d; // delayed input for edge detection

    // Synchronous input sampling for edge detection
    always @(posedge clk) begin
        if (reset) begin
            in_d <= 1'b1; // line idle high at reset
        end else begin
            in_d <= in;
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for falling edge: in_d=1, in=0 start bit start
                if (in_d == 1'b1 && in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // Confirm start bit still 0
                if (in == 1'b0)
                    next_state = DATA;
                else
                    // false start or glitch, back to IDLE
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = DATA;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;  // correct stop bit, ready for next byte
                else
                    next_state = STOP_CHECK; // wait for valid stop bit
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, shift register, done pulse
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_cnt   <= 3'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default no done

            case (next_state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_cnt   <= 3'd0;
                end

                START: begin
                    // prepare to receive data bits; no change to shift_reg or bit_cnt here
                end

                DATA: begin
                    // Shift in LSB first: shift right, insert new bit at MSB is not correct since LSB first.
                    // Instead shift right and put new bit at bit 7 (MSB) ? Actually, easier to shift right and insert at MSB.
                    // But spec says LSB first -> means incoming bit is the LSB.
                    // So to shift LSB first, shift right and insert at bit 7 (MSB) does not make sense.
                    // Instead, shift left and insert new bit at LSB (like original code).
                    // shift_reg <= {shift_reg[6:0], in};
                    // But to keep LSB first correct, shift left and insert at LSB.

                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1)
                        done <= 1'b1;
                end

            endcase
        end
    end

endmodule