module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        WAIT_STOP  = 2'b11
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count; // counts 0 to 7 for 8 data bits
    reg [7:0] shift_reg;

    // Sequential state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done to 0, will be set in CHECK_STOP on success

            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    shift_reg <= 8'b0;
                end
                RECEIVE: begin
                    // Shift in data bits LSB first
                    // On each clock in RECEIVE state, sample 'in' as next data bit
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                CHECK_STOP: begin
                    // nothing to update here other than done signal and prepare for next byte
                end
                WAIT_STOP: begin
                    // nothing to update other than waiting for stop bit to appear
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit == 0 to begin receiving
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
                    // Stop bit correct, one byte done
                    next_state = IDLE;
                end else begin
                    // Stop bit incorrect, wait for stop bit to appear
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                // Wait here until stop bit (line == 1) is detected
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
        endcase
    end

    // done output logic: synchronous, single clock pulse when a byte correctly received
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else if (state == CHECK_STOP && in == 1'b1) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

endmodule