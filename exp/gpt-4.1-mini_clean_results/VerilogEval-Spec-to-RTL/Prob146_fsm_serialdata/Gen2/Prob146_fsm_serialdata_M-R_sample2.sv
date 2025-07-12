module TopModule(
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        STOP_WAIT  = 2'd2,
        ERROR_WAIT = 2'd3
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift;
    reg [3:0] bit_count;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, move to STOP_WAIT
                if (bit_count == 4'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end

            STOP_WAIT: begin
                // If stop bit valid (1), go to IDLE and assert done
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;  // invalid stop bit, wait here
            end

            ERROR_WAIT: begin
                // Wait until in == 1 (valid stop bit) then go IDLE, no done asserted
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            data_shift <= 8'd0;
            bit_count  <= 4'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default no done pulse

            case(state)
                IDLE: begin
                    bit_count  <= 4'd0;
                    data_shift <= 8'd0;
                    // Wait for start bit, no shifts or done here
                end

                RECEIVE: begin
                    // Shift in LSB first by shifting right and inserting new bit at MSB = WRONG
                    // Correction: Shift right and insert new bit at MSB means MSB first
                    // For LSB first, shift left and insert at LSB:
                    data_shift <= {in, data_shift[7:1]};
                    bit_count  <= bit_count + 1;
                end

                STOP_WAIT: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                    // else no done and transition handled by next_state
                end

                ERROR_WAIT: begin
                    // Do nothing, just wait for stop bit == 1
                end

                default: ;
            endcase
        end
    end

endmodule