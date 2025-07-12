module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    // States: WAIT_START, RECEIVE_BITS, WAIT_STOP, ERROR_WAIT
    typedef enum reg [1:0] {
        WAIT_START   = 2'd0,
        RECEIVE_BITS = 2'd1,
        WAIT_STOP    = 2'd2,
        ERROR_WAIT   = 2'd3
    } state_t;

    reg [1:0] state, next_state;

    reg [2:0] bit_index;     // Counts 0..7 for data bits received
    reg [7:0] shift_reg;     // Shift register for data bits, LSB first

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state      <= WAIT_START;
            bit_index  <= 3'd0;
            shift_reg  <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, pulse done only on valid stop bit
            done <= 1'b0;

            case (state)
                WAIT_START: begin
                    bit_index <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE_BITS: begin
                    // Shift in new bit at LSB, shift previous bits right
                    // LSB first means bit 0 comes first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_index <= bit_index + 1'b1;
                end

                WAIT_STOP: begin
                    // On stop bit cycle, if valid, latch data and assert done
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done     <= 1'b1;
                    end
                    // else done remains 0 and no output update
                    // bit_index and shift_reg stay unchanged
                end

                ERROR_WAIT: begin
                    // No change to bit_index or shift_reg in error recovery
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            WAIT_START: begin
                // Wait for start bit (logic 0) on line
                if (in == 1'b0)
                    next_state = RECEIVE_BITS;
                else
                    next_state = WAIT_START;
            end

            RECEIVE_BITS: begin
                // After 8 bits received, go to STOP bit sampling
                if (bit_index == 3'd7)
                    next_state = WAIT_STOP;
                else
                    next_state = RECEIVE_BITS;
            end

            WAIT_STOP: begin
                if (in == 1'b1)       // Valid stop bit
                    next_state = WAIT_START;
                else                  // Invalid stop bit, wait for line idle
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                // Stay here until line returns to idle (logic 1)
                if (in == 1'b1)
                    next_state = WAIT_START;
                else
                    next_state = ERROR_WAIT;
            end
        endcase
    end

endmodule