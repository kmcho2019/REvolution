module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE      = 3'd0,
        START     = 3'd1,
        DATA      = 3'd2,
        STOP_WAIT = 3'd3,
        DONE      = 3'd4
    } state_t;

    reg [2:0] state, next_state;
    reg [3:0] bit_count; // 4 bits to count up to 8
    reg [7:0] data_shift; // To store the 8 data bits (not actually used but for clarity)

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // Default done to 0, will assert 1 only in DONE state
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift <= 8'b0;
                end

                START: begin
                    bit_count <= 0;
                    data_shift <= 8'b0;
                end

                DATA: begin
                    // Shift in data bits LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP_WAIT: begin
                    bit_count <= 0;
                    data_shift <= 8'b0;
                end

                DONE: begin
                    bit_count <= 0;
                    data_shift <= 8'b0;
                    done <= 1'b1;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit = 0 (line normally 1)
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // After detecting start bit, move to DATA to sample bits
                // We assume bits arrive one per clock cycle
                next_state = DATA;
            end

            DATA: begin
                if (bit_count == 7) // after next bit, 8 bits collected
                    next_state = (in == 1'b1) ? DONE : STOP_WAIT;
                else
                    next_state = DATA;
            end

            STOP_WAIT: begin
                // Wait until line returns to 1 (stop bit detected)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP_WAIT;
            end

            DONE: begin
                // One clock cycle done asserted then back to IDLE
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule