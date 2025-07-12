module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    typedef enum reg [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        STOP       = 2'b10,
        ERROR_WAIT = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt;       // Counts from 0 to 7
    reg [7:0] shift_reg;

    // Next state and outputs combinational logic
    always @(*) begin
        // Defaults
        next_state = state;
        done = 1'b0;

        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, move to STOP
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1) begin
                    // Correct stop bit, byte done
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Stop bit error, wait until stop bit (1) appears
                    next_state = ERROR_WAIT;
                end
            end

            ERROR_WAIT: begin
                // Wait until stop bit detected
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    // Shift reg not updated here
                end

                RECEIVE: begin
                    // Shift in LSB first: right shift + insert bit at MSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                    end
                    bit_cnt <= 3'd0;
                end

                ERROR_WAIT: begin
                    bit_cnt <= 3'd0;
                end
            endcase

            // done is asserted combinationally in the always @(*) block,
            // so we latch it here to make it synchronous one cycle pulse.
            // Alternatively done could be combinational output. Here we keep registered.
            done <= done;
        end
    end

endmodule