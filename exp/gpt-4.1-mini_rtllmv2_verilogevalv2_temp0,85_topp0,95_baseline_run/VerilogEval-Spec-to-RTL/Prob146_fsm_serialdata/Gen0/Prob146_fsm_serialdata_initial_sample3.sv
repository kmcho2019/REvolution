module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        WAIT_STOP_BIT = 3'd4
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;  // count from 0 to 7 for data bits
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low, only set high for one cycle when done

            case (state)
                IDLE: begin
                    // wait for start bit (0)
                    if (in == 1'b0) begin
                        // start bit detected
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end
                START: begin
                    // should stay one clock cycle, no action here
                end
                DATA: begin
                    // Shift in data bits LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // if stop bit (in) == 1, output done and byte
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        out_byte <= shift_reg;
                    end
                    // else we will wait for stop bit
                end
                WAIT_STOP_BIT: begin
                    if (in == 1'b1) begin
                        // stop bit detected, ready to receive next byte
                        done <= 1'b1;
                        out_byte <= shift_reg;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (!reset && in == 1'b0)
                    next_state = START;
            end
            START: begin
                // After one clock in start bit, proceed to data
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    // correct stop bit, go back to IDLE
                    next_state = IDLE;
                end else begin
                    // invalid stop bit, wait until stop bit seen
                    next_state = WAIT_STOP_BIT;
                end
            end
            WAIT_STOP_BIT: begin
                if (in == 1'b1) begin
                    // stop bit detected, go back to IDLE
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP_BIT;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule