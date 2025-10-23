module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    typedef enum reg [1:0] {
        IDLE       = 2'b00,
        START      = 2'b01,
        DATA       = 2'b10,
        STOP_CHECK = 2'b11
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;       // Counts bits received (0 to 7)
    reg [7:0] shift_reg;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)           // Detect start bit low
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // Confirm start bit still low, else back to IDLE
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = DATA;
            end

            STOP_CHECK: begin
                // If stop bit is correct (high), return to IDLE and done is asserted
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    // Stay here until stop bit becomes high (framing error recovery)
                    next_state = STOP_CHECK;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, shift register, done output
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START: begin
                    // No counter or shift_reg update here
                end

                DATA: begin
                    // Shift in new bit at LSB, shift existing bits right to MSB
                    // LSB first per protocol: in goes to shift_reg[0]
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end

                STOP_CHECK: begin
                    // done asserted for one cycle if valid stop bit
                    if (in == 1'b1)
                        done <= 1'b1;
                    else
                        done <= 1'b0;

                    // No resets here; wait in this state on framing error
                end
            endcase
        end
    end

endmodule