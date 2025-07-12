module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot FSM states
    localparam IDLE       = 5'b00001,
               START_BIT  = 5'b00010,
               DATA_BITS  = 5'b00100,
               STOP_BIT   = 5'b01000,
               ERROR_WAIT = 5'b10000;

    reg [4:0] state, next_state;
    reg [2:0] bit_count;      // Counts bits received [0..7]
    reg [7:0] shift_reg;      // Shift register for data bits

    // Next-state combinational logic
    always @(*) begin
        next_state = state;  // Default hold

        case (state)
            IDLE: begin
                // Idle line is '1'; look for start bit '0'
                if (in == 1'b0)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end

            START_BIT: begin
                // Confirm start bit (should remain 0)
                // If start bit glitch (input goes high), go back to IDLE
                if (in == 1'b0)
                    next_state = DATA_BITS;
                else
                    next_state = IDLE;
            end

            DATA_BITS: begin
                if (bit_count == 3'd7)
                    next_state = STOP_BIT;
                else
                    next_state = DATA_BITS;
            end

            STOP_BIT: begin
                // Check stop bit: '1' means success, else framing error
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                // Wait here until a stop bit (1) is detected to re-sync
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state updates, shift register, counters, done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // Default done low each cycle

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START_BIT: begin
                    // Just confirm start bit, no changes here
                end

                DATA_BITS: begin
                    // Shift right by 1, insert input at MSB (LSB-first reception)
                    // Incoming bit is first bit sent (LSB first), so newest bit is inserted at MSB,
                    // gradually shifting data toward LSB to reconstruct the byte in order.
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP_BIT: begin
                    // If stop bit is correct, pulse done high
                    if (in == 1'b1)
                        done <= 1'b1;
                    bit_count <= 3'd0; // Reset for next byte
                end

                ERROR_WAIT: begin
                    // Hold counters and shift_reg stable, reset bit_count for safety
                    bit_count <= 3'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

endmodule