module TopModule(
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        STOP_CHECK = 2'd2,
        ERROR_WAIT = 2'd3
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift;
    reg [3:0] bit_count;

    // Next state combinational logic
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
                if (bit_count == 4'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Valid stop bit: go idle
                else
                    next_state = ERROR_WAIT; // Invalid stop bit: wait for line idle
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Wait for valid stop bit before restarting
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counter, shift register, outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 4'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done de-asserted
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_count  <= 4'd0;
                    data_shift <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right with new bit at MSB to receive LSB first:
                    // At each bit, the incoming bit becomes MSB, data shifts right,
                    // so after 8 bits, LSB is first received bit
                    data_shift <= {in, data_shift[7:1]};
                    bit_count  <= bit_count + 1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1; // Assert done for one cycle on valid stop bit
                    end
                    // else stay without done, error state handled by FSM
                end

                ERROR_WAIT: begin
                    // Wait until line goes high, no changes
                end

                default: ;
            endcase
        end
    end

endmodule