module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // FSM states
    typedef enum logic [2:0] {
        IDLE       = 3'd0,
        DATA       = 3'd1,
        STOP_CHECK = 3'd2,
        ERROR      = 3'd3,
        WAIT_IDLE  = 3'd4
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_idx;       // Counts bits received (0-7)
    reg [7:0] shift_reg;     // Shift register for received byte

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;    // Start bit detected
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_idx == 3'd7)
                    next_state = STOP_CHECK;  // After last data bit
                else
                    next_state = DATA;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;     // Valid stop bit, ready for next byte
                else
                    next_state = ERROR;    // Framing error
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = WAIT_IDLE;  // Stop bit found, wait line idle
                else
                    next_state = ERROR;
            end

            WAIT_IDLE: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Line idle again, wait for next start
                else
                    next_state = WAIT_IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential state updates and data sampling
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_idx   <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // Shift in LSB first: shift_reg[0] = new bit each cycle, shift left
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_idx   <= bit_idx + 1'b1;
                end

                STOP_CHECK: begin
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                ERROR: begin
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                WAIT_IDLE: begin
                    // Hold bit_idx and shift_reg at zero to prepare for next start
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Mealy output done is high when in STOP_CHECK state and input is the valid stop bit 1
    assign done = (state == STOP_CHECK) && (in == 1'b1);

endmodule