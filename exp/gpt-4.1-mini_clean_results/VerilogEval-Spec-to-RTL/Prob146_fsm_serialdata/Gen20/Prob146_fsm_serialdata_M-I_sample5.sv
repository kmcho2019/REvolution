module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam [1:0]
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        RECOVER    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // done pulse register
    reg done_pulse;

    // Sequential logic: state, counters, shift register
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done_pulse <= 1'b0;
        end else begin
            state <= next_state;

            // Default done_pulse low, set only in CHECK_STOP with valid stop bit
            done_pulse <= 1'b0;

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in LSB first: shift left, input bit to bit 0
                    shift_reg <= {shift_reg[6:0], in};
                    bit_cnt   <= bit_cnt + 3'd1;
                end

                CHECK_STOP: begin
                    bit_cnt <= 3'd0;
                    if (in == 1'b1) begin
                        // Valid stop bit
                        done_pulse <= 1'b1;
                        out_byte <= shift_reg;
                    end
                    // else remain in recovery or other states
                end

                RECOVER: begin
                    bit_cnt <= 3'd0;
                    // Hold shift_reg stable to reduce toggling
                    shift_reg <= shift_reg;
                end

                default: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // done output registered, pulses one clock cycle
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            done <= done_pulse;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)  // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;     // valid stop bit, go idle
                else
                    next_state = RECOVER;  // invalid stop bit, recover
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;     // line back to idle
                else
                    next_state = RECOVER;  // keep recovering
            end

            default: next_state = IDLE;
        endcase
    end

endmodule