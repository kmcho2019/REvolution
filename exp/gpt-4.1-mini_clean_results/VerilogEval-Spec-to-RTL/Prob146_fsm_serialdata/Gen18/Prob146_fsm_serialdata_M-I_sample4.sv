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
        STOP       = 2'b10,
        ERROR_WAIT = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Next state logic and outputs combinational
    always @(*) begin
        // Default assignments
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                // Line idle is high; start bit is detected when in == 0
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1) begin
                    // Stop bit correct: output done pulse
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Stop bit incorrect, go to error wait
                    next_state = ERROR_WAIT;
                end
            end

            ERROR_WAIT: begin
                // Wait for line to go high (stop bit detected)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Sequential logic for state, bit counter, and shift register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (next_state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                end

                RECEIVE: begin
                    bit_cnt <= bit_cnt + 3'd1;
                    // Shift in LSB first: new bit goes to LSB, shift right
                    // Because serial sends LSB first, new bit is shift_reg[7:1] + in at bit 0
                    shift_reg <= {in, shift_reg[7:1]};
                end

                STOP: begin
                    // bit_cnt stays as is
                    // On stop state done pulse will be generated combinationally
                    // Preserve shift_reg
                end

                ERROR_WAIT: begin
                    // Hold bit counter and shift register stable during error wait
                end
            endcase

            // Update out_byte and done on STOP with correct stop bit
            if (state == STOP && in == 1'b1) begin
                out_byte <= shift_reg;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule