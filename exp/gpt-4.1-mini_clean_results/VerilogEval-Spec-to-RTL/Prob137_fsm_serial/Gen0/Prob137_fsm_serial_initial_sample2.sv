module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states
    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3,
        ERROR = 3'd4
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;      // Counts data bits received (0-7)
    reg [7:0] data_shift;     // Stores received data bits

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done is 0, assert only on successful STOP
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
                START: begin
                    // start bit verified, no updates here
                end
                DATA: begin
                    // Shift in data bits LSB first on each clock
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // If stop bit is correct, done is asserted below
                end
                ERROR: begin
                    // Wait until line returns to idle (1)
                end
            endcase
        end
    end

    // Next state logic and done output generation
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                // Wait for start bit 0
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                // Confirm start bit still 0
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // noise, go back idle
            end
            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1) begin
                    // Correct stop bit, indicate done for one cycle and go to IDLE
                    next_state = IDLE;
                end else begin
                    // Stop bit not correct, go to error state to wait stop bit
                    next_state = ERROR;
                end
            end
            ERROR: begin
                // Stay in error until line returns to 1 (stop bit)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

    // done pulse generation: done asserted for one cycle in STOP on correct stop bit
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else if (state == STOP && in == 1'b1) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

endmodule