module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot FSM state encoding
    localparam IDLE          = 5'b00001;
    localparam START         = 5'b00010;
    localparam DATA_BITS     = 5'b00100;
    localparam STOP          = 5'b01000;
    localparam ERROR_RECOVERY= 5'b10000;

    reg [4:0] state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;

    // To detect falling edge on 'in' for start bit detection
    reg in_dly;

    // Edge detection and FSM next state logic combinational
    always @(*) begin
        next_state = state;  // default stay in current state
        case (state)
            IDLE: begin
                // Detect falling edge on line from idle (1) to start bit (0)
                if (in_dly == 1'b1 && in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // Confirm start bit still zero, else back to IDLE
                if (in == 1'b0)
                    next_state = DATA_BITS;
                else
                    next_state = IDLE;
            end

            DATA_BITS: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA_BITS;
            end

            STOP: begin
                // Check stop bit correctness
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_RECOVERY;
            end

            ERROR_RECOVERY: begin
                // Wait until stop bit (1) detected to resync
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_RECOVERY;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential block for FSM state, counters, shift reg and done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            in_dly    <= 1'b1; // Assume idle line is high on reset
        end else begin
            state <= next_state;

            // Delay input to detect edges
            in_dly <= in;

            // Default done low every clock
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START: begin
                    // nothing else to do here besides state transition
                end

                DATA_BITS: begin
                    // Shift LSB first: shift right, new bit goes to MSB
                    // This places first received bit into bit 0 eventually after 8 shifts
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end

                STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1;
                    // bit_cnt and shift_reg hold until next byte or reset
                end

                ERROR_RECOVERY: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

endmodule