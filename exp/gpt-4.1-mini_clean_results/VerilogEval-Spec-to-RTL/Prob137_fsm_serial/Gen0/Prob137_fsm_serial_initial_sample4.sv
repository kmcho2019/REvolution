module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // States
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA_BITS = 3'b010,
        STOP = 3'b011,
        WAIT_STOP = 3'b100
    } state_t;

    reg [2:0] state, next_state;
    reg [3:0] bit_count;  // counts from 0 to 7 for 8 data bits
    reg [7:0] data_shift;

    // Sequential state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done is 0; set to 1 only one clock when byte received correctly
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift <= 8'b0;
                end

                START: begin
                    // No shifting in START state
                end

                DATA_BITS: begin
                    // Shift in LSB first: on each clock, shift in 'in' into data_shift
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // done asserted if stop bit is 1, no shifting here
                    // no bit_count change
                end

                WAIT_STOP: begin
                    // Waiting for line to go high (stop bit detected)
                    // bit_count and data_shift remain unchanged
                end
            endcase
        end
    end

    // Next state and done logic combinational
    always @* begin
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // After detecting start bit, immediately move to DATA_BITS to receive first data bit
                next_state = DATA_BITS;
            end

            DATA_BITS: begin
                if (bit_count == 4'd7) // Received 8 bits total (0 to 7)
                    next_state = STOP;
                else
                    next_state = DATA_BITS;
            end

            STOP: begin
                if (in == 1'b1) begin
                    // Stop bit is correct
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Stop bit incorrect, enter WAIT_STOP to wait for stop bit to appear
                    next_state = WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                // Remain here until line goes high (stop bit received)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule