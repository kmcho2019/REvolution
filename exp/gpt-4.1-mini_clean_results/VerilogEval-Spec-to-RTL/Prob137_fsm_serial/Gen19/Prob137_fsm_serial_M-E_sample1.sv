module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding (5 states)
    localparam IDLE         = 5'b00001;
    localparam START_CHECK  = 5'b00010;
    localparam RECEIVE_BITS = 5'b00100;
    localparam STOP_CHECK   = 5'b01000;
    localparam ERROR_WAIT   = 5'b10000;

    reg [4:0] state, next_state;
    reg [3:0] bit_count;        // up to 8 bits, 4 bits to allow counting 0-8
    reg [7:0] shift_reg;

    // Next state logic combinational
    always @(*) begin
        // Default next state same as current
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit (line goes low)
                if (in == 1'b0)
                    next_state = START_CHECK;
            end

            START_CHECK: begin
                // Confirm that start bit is still 0 in next clock
                // If not zero, false start, back to idle
                if (in == 1'b0)
                    next_state = RECEIVE_BITS;
                else
                    next_state = IDLE;
            end

            RECEIVE_BITS: begin
                // After receiving 8 bits, go to stop bit check
                if (bit_count == 4'd8)
                    next_state = STOP_CHECK;
            end

            STOP_CHECK: begin
                // If stop bit is 1, byte done, else error recovery
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                // Wait until line goes idle (1)
                if (in == 1'b1)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 4'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // Default low, pulse on stop bit success

            case (state)
                IDLE: begin
                    bit_count <= 4'd0;
                    shift_reg <= 8'd0;
                end

                START_CHECK: begin
                    // no counters or registers updated here; just verify start bit stable
                end

                RECEIVE_BITS: begin
                    // Shift in LSB first:
                    // Shift register left by 1, insert new bit at LSB
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end

                STOP_CHECK: begin
                    // Check stop bit
                    if (in == 1'b1)
                        done <= 1'b1; // Valid byte received
                    // bit_count will be reset at next IDLE state
                end

                ERROR_WAIT: begin
                    bit_count <= 4'd0;
                    shift_reg <= 8'd0;
                    // Remain here until line goes idle
                end

                default: begin
                    bit_count <= 4'd0;
                    shift_reg <= 8'd0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

endmodule