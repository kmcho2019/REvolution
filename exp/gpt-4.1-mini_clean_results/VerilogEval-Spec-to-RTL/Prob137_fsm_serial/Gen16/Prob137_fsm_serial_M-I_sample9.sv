module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states encoded in 2 bits
    localparam IDLE       = 2'd0,
               RECEIVE    = 2'd1,
               CHECK_STOP = 2'd2,
               WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;    // Counts received data bits [0..7]
    reg [7:0] shift_reg;    // Shift register for data bits

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After 8 data bits received, move to check stop bit
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)       // Valid stop bit
                    next_state = IDLE;
                else                  // Framing error - wait for stop bit
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Remain here until stop bit (1) detected
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, shift register, done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0 each cycle
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Reset bit counter and shift reg only in IDLE for minimal toggling
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift left by 1, insert new bit at LSB (LSB-first)
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1;  // Assert done pulse on correct stop bit
                    bit_count <= 3'd0;  // Reset bit counter here for next frame
                    // Do not reset shift_reg here; data available if needed
                end

                WAIT_STOP: begin
                    // Reset counters and shift register to stable known state while waiting
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

endmodule