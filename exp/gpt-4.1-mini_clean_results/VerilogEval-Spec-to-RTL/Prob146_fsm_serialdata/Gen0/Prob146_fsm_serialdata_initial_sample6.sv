module TopModule(
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
        WAIT_STOP = 3'd4
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;        // to count 8 data bits
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done to 0 each cycle

            case(state)
                IDLE: begin
                    // Wait for start bit 0
                    if (in == 1'b0) begin
                        bit_count <= 3'd0;
                        data_reg <= 8'd0;
                    end
                end
                START: begin
                    // Nothing to do here, just move on
                end
                DATA: begin
                    // Shift in data bit (LSB first)
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    // Nothing here
                end
                WAIT_STOP: begin
                    // Waiting for stop bit = 1
                end
            endcase

            // Update output and bit_count done in sequential logic above
            if(state == STOP && in == 1'b1) begin
                out_byte <= data_reg;
                done <= 1'b1;
            end
        end
    end

    always @(*) begin
        // Default next state is current state
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0) // detected start bit
                    next_state = START;
            end
            START: begin
                // Move to DATA on next clock after start bit detection
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    // Stop bit correct, next IDLE for next byte
                    next_state = IDLE;
                end else begin
                    // Stop bit incorrect, wait for stop bit to recover
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule