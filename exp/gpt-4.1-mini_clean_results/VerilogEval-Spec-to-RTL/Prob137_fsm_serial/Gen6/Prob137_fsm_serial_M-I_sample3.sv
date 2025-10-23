module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Binary encoded FSM states
    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        WAIT_STOP  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;    // counts 0..7 data bits
    reg [7:0] shift_reg;    // shift register for data bits

    reg done_next;

    // Combinational logic for next state and done signal
    always @(*) begin
        next_state = state;
        done_next = 1'b0;

        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    done_next = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
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

    // Sequential logic for state, shift_reg, bit_count and done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done_next;

            case(state)
                IDLE: begin
                    // No shifting or counting in IDLE to reduce toggling
                end

                RECEIVE: begin
                    // Shift in LSB first: shift left, new bit into LSB
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    // No shift or count updates here to avoid toggling
                    // bit_count and shift_reg implicitly reset on next reset or on IDLE state when receiving new byte
                end

                WAIT_STOP: begin
                    // No shift or count updates here
                end

                default: begin
                    // Should not occur
                end
            endcase

            // Clear bit_count and shift_reg on transitions to IDLE from CHECK_STOP or WAIT_STOP
            // to prepare for next byte and avoid resetting every clock cycle in IDLE
            if ((state != IDLE) && (next_state == IDLE)) begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end
        end
    end

endmodule