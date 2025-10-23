module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot FSM states
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_next;

    // Combinational logic for next state and done_next
    always @(*) begin
        next_state = state;
        done_next = 1'b0;

        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, move to CHECK_STOP
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    done_next = 1'b1; // Valid stop bit -> pulse done
                    next_state = IDLE;
                end else begin
                    // Framing error -> wait for stop bit
                    next_state = WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                // Wait until line returns to idle (1) before starting next byte
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done_next;

            case (state)
                IDLE: begin
                    // No shift/count updates here to reduce toggling
                end

                RECEIVE: begin
                    // Shift left: insert new bit at LSB, per LSB-first protocol
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // No shift/count updates to avoid toggling
                end

                WAIT_STOP: begin
                    // No shift/count updates here
                end

                default: begin
                    // Should not occur
                end
            endcase

            // Reset bit_count and shift_reg on transition to IDLE
            if ((state != IDLE) && (next_state == IDLE)) begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end
        end
    end

endmodule