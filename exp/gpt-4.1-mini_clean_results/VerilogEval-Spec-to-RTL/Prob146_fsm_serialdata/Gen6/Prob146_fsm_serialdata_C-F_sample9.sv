module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding: 2 bits for 4 states
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        STOP_WAIT  = 2'd2,
        ERROR_WAIT = 2'd3
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_count; // Counts 0 to 7 for 8 bits received

    // Next-state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)      // Start bit detected (line goes low)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end

            STOP_WAIT: begin
                if (in == 1'b1)      // Valid stop bit
                    next_state = IDLE;
                else                 // Invalid stop bit
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                if (in == 1'b1)      // Wait until line returns to idle (stop bit)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state transitions, data shifting, outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, only asserted one cycle on valid stop bit
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count  <= 3'd0;
                    data_shift <= 8'd0;
                    // Wait for start bit; no shifting here
                end

                RECEIVE: begin
                    // Shift in LSB first: shift left by 1, insert 'in' at LSB
                    data_shift <= {in, data_shift[7:1]}; // This is MSB-first shift (wrong)
                    // Correction for LSB-first:
                    // Shift left and insert new bit at LSB:
                    data_shift <= {data_shift[6:0], in};
                    bit_count <= bit_count + 1;
                end

                STOP_WAIT: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                    // else no done, transition to ERROR_WAIT handled by next_state
                end

                ERROR_WAIT: begin
                    // Wait here until stop bit (in == 1) to resume
                end

                default: ;
            endcase
        end
    end

endmodule