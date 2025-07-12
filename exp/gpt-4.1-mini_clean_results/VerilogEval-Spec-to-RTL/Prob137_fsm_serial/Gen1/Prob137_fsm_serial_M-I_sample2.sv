module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Define FSM states
    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        WAIT_STOP  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;      // Counts data bits received: 0 to 7
    reg [7:0] shift_reg;      // Shift register for 8 data bits

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done <= 1'b0;
                end

                RECEIVE: begin
                    // Shift left, LSB first means newest bit goes into LSB position
                    // shift_reg[6:0] moves left, in goes into bit0 (LSB)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                    done <= 1'b0;
                end

                CHECK_STOP: begin
                    // done is asserted if stop bit is valid (in == 1)
                    done <= (in == 1'b1) ? 1'b1 : 1'b0;
                end

                WAIT_STOP: begin
                    done <= 1'b0;
                end

                default: begin
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit = 0 (line low) to begin reception
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 data bits, move to CHECK_STOP
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    // Correct stop bit received, go back to IDLE for next byte
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit, wait for line to return high
                    next_state = WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                // Wait until stop bit (line = 1) is detected
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule