module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (binary)
    typedef enum logic [1:0] {
        IDLE       = 2'b00, // Waiting for start bit (line low)
        RECEIVE    = 2'b01, // Receiving 8 data bits
        STOP_CHECK = 2'b10, // Checking stop bit
        ERROR      = 2'b11  // Waiting for line idle after framing error
    } state_t;

    state_t state, next_state;

    reg [7:0] data_accumulator;
    reg [2:0] bit_count; // counts 0..7 for data bits received

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;    // valid stop bit, ready for next frame
                else
                    next_state = ERROR;   // framing error, wait for idle
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_accumulator <= 8'b0;
            bit_count <= 3'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done

            case (state)
                IDLE: begin
                    data_accumulator <= 8'b0;
                    bit_count <= 3'b0;
                end

                RECEIVE: begin
                    // Shift in least significant bit first (shift right)
                    // New bit goes into MSB; to keep LSB first order,
                    // shift right and put in MSB
                    data_accumulator <= {in, data_accumulator[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1)
                        done <= 1'b1; // one-cycle pulse at stop bit when valid
                    // else no done, error handled by next_state
                end

                ERROR: begin
                    // hold data_accumulator and bit_count unchanged
                end
            endcase
        end
    end

endmodule