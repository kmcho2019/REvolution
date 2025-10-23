module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;        // Counts data bits received from 0 to 7
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default done low each cycle

            case (state)
                IDLE: begin
                    // Wait for start bit (0)
                    // No action needed on data_reg or bit_count here
                end
                START: begin
                    // Just a one-cycle delay after start bit detected, no data capture here
                end
                DATA: begin
                    // Capture the bit into data_reg at position bit_count
                    data_reg[bit_count] <= in;
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    // If stop bit correct, output data and assert done next cycle
                    // No register updates here except done and out_byte after state update
                end
                WAIT_STOP: begin
                    // Wait for line to go high (stop bit) to resync
                    // No data_reg or bit_count changes here
                end
            endcase

            // When in STOP and stop bit is correct, latch data to out_byte and assert done
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_reg;
                done <= 1'b1;
            end

            // Reset bit_count and data_reg at proper transitions
            if ((state == IDLE && next_state == START) || (state == WAIT_STOP && next_state == IDLE)) begin
                bit_count <= 3'd0;
                data_reg <= 8'd0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)  // Start bit detected
                    next_state = START;
            end
            START: begin
                // Move to DATA state on next clock cycle after start bit
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    // After receiving 8 bits, move to STOP state
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    // Stop bit correct, ready for next byte
                    next_state = IDLE;
                end else begin
                    // Stop bit incorrect, wait for resync
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1) begin
                    // Stop bit found, go to IDLE to wait next start bit
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule