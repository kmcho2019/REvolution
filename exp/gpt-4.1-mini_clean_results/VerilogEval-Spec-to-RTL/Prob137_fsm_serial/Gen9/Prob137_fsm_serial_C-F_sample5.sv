module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot FSM states
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Sequential logic: state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to zero each cycle; pulse in CHECK_STOP if stop bit valid
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift left by 1, insert new bit at LSB (LSB first)
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    // Pulse done when stop bit correct (1)
                    if (in == 1'b1)
                        done <= 1'b1;
                    // bit_count not needed here, keep as is or cleared in IDLE/WAIT_STOP
                end

                WAIT_STOP: begin
                    // Wait for stop bit; clear bit_count and shift_reg once here
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    // Defensive default resets
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Combinational next_state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Detect start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After 8 data bits received, go to check stop bit
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                // Correct stop bit: back to IDLE
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    // Framing error, wait for stop bit
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Wait for line to return to idle state (stop bit = 1)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule