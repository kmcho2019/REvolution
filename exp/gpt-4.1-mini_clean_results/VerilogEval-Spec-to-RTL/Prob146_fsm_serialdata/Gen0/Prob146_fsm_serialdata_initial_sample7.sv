module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    typedef enum reg [2:0] {
        IDLE      = 3'd0,
        START     = 3'd1,
        DATA      = 3'd2,
        STOP      = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt;       // counts from 0 to 7 for data bits
    reg [7:0] data_shift;    // shift register for data bits

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state    <= IDLE;
            bit_cnt  <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done     <= 1'b0;
        end else begin
            state <= next_state;

            // Clear done by default; asserted only for one cycle when a byte is done
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Nothing to do here
                    bit_cnt <= 3'd0;
                    data_shift <= 8'd0;
                end
                START: begin
                    bit_cnt <= 3'd0;
                    data_shift <= 8'd0;
                end
                DATA: begin
                    // Shift in data bits LSB first from 'in'
                    data_shift <= {in, data_shift[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;
                end
                STOP: begin
                    // If stop bit valid (in == 1), latch data and assert done
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // Waiting for line to return to 1 before next start bit
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Wait for start bit (in==0)
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                // On next cycle, collect data bits
                next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;        // valid stop bit, ready for next byte
                else
                    next_state = WAIT_STOP;   // wait for stop bit before next start
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule