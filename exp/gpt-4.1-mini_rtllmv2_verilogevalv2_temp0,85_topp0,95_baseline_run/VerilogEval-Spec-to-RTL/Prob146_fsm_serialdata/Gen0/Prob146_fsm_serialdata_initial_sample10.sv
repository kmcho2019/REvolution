module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        START = 2'd1,
        DATA  = 2'd2,
        STOP  = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;  // Counts 0 to 7 for data bits
    reg [7:0] shift_reg;

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low, only asserted in STOP when stop bit correct

            case (state)
                IDLE: begin
                    // nothing to do here, next_state logic handles start bit detection
                end

                START: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // shift in data bits LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // stop bit correct, output byte and assert done
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    // else done = 0 (default), keep waiting for stop bit
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START; // start bit detected
                else
                    next_state = IDLE;
            end

            START: begin
                // move to DATA to collect bits next clock
                next_state = DATA;
            end

            DATA: begin
                if (bit_count == 3'd7) // received last data bit
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1) // stop bit detected correctly
                    next_state = IDLE;
                else
                    next_state = STOP; // wait until stop bit is seen
            end

            default: next_state = IDLE;
        endcase
    end

endmodule