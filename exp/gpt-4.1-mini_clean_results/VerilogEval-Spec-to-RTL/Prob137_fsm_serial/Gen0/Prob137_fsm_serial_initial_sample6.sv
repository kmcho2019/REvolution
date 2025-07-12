module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    typedef enum logic [2:0] {
        IDLE      = 3'd0,
        START     = 3'd1,
        DATA      = 3'd2,
        STOP      = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;

    state_t state, next_state;
    reg [3:0] bit_cnt;  // 0 to 8 for data bits
    reg [7:0] data_shift;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 4'd0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in == 1'b0) begin
                        // start bit detected
                        bit_cnt <= 4'd0;
                    end
                end
                START: begin
                    done <= 1'b0;
                    bit_cnt <= 4'd0;
                end
                DATA: begin
                    done <= 1'b0;
                    // shift in the data bit (LSB first)
                    data_shift <= {in, data_shift[7:1]};
                    bit_cnt <= bit_cnt + 1;
                end
                STOP: begin
                    // done asserted for one clock cycle if stop bit correct
                    done <= (in == 1'b1) ? 1'b1 : 1'b0;
                end
                WAIT_STOP: begin
                    done <= 1'b0;
                end
                default: done <= 1'b0;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (reset) next_state = IDLE;
                else if (in == 1'b0) next_state = START;
                else next_state = IDLE;
            end
            START: begin
                // Confirm start bit still 0
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // noise or error, wait for start bit again
            end
            DATA: begin
                if (bit_cnt == 4'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;  // valid byte received, ready for next start
                else
                    next_state = WAIT_STOP;  // error, wait for stop bit
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule