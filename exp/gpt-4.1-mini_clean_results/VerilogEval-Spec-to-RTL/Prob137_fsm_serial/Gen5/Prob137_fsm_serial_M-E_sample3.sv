module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (binary)
    localparam [2:0]
        IDLE       = 3'd0,
        START      = 3'd1,
        DATA       = 3'd2,
        STOP_CHECK = 3'd3,
        ERROR_WAIT = 3'd4;

    reg [2:0] state, next_state;
    reg [2:0] bit_cnt;

    // Sequential logic: state transitions, counters, done output
    always @(posedge clk) begin
        if (reset) begin
            state   <= IDLE;
            bit_cnt <= 3'd0;
            done    <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0, asserted only for one cycle in STOP_CHECK on valid stop bit
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_cnt <= 3'd0; // Clear counter on idle
                end

                START: begin
                    bit_cnt <= 3'd0; // Start counting data bits
                end

                DATA: begin
                    bit_cnt <= bit_cnt + 1'b1; // Count each data bit received
                end

                STOP_CHECK: begin
                    // done asserted if stop bit valid (in==1)
                    if (in == 1'b1)
                        done <= 1'b1;
                end

                ERROR_WAIT: begin
                    // No actions needed here
                end

                default: begin
                    bit_cnt <= 3'd0;
                    done    <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for start bit (0) to begin
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // After start bit detected, next sample data bit #0
                next_state = DATA;
            end

            DATA: begin
                // After 8 data bits (bit_cnt counts 0..7), go check stop bit
                if (bit_cnt == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = DATA;
            end

            STOP_CHECK: begin
                // If stop bit is 1, valid byte received, return to IDLE
                // else go to ERROR_WAIT to wait for line to return to idle
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                // Wait here until line returns to stop bit (1), then IDLE
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule