module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot FSM states encoded in 4 bits
    localparam IDLE       = 4'b0001,
               RECEIVE    = 4'b0010,
               CHECK_STOP = 4'b0100,
               WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;    // Counts received data bits [0..7]
    reg [7:0] shift_reg;    // Shift register for data bits

    reg done_next;

    // Combinational next state logic
    always @(*) begin
        next_state = IDLE;
        case (state)
            IDLE: begin
                // Wait for start bit (0)
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
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state, bit_count, shift_reg, and done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            done_next <= 1'b0;
        end else begin
            state <= next_state;

            // Default done_next to 0
            done_next <= 1'b0;

            case (state)
                IDLE: begin
                    // Clear bit_count and shift_reg only when starting reception
                    // To reduce toggling, keep them stable otherwise
                    if (next_state == RECEIVE) begin
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in new bit LSB-first only while receiving
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // If stop bit correct, assert done_next pulse
                    if (in == 1'b1) begin
                        done_next <= 1'b1;
                    end
                    // Reset bit_count for next reception
                    bit_count <= 3'd0;
                    // Keep shift_reg stable for possible use
                end

                WAIT_STOP: begin
                    // Keep bit_count and shift_reg stable to reduce toggling
                    // Wait until stop bit detected
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done_next <= 1'b0;
                end
            endcase

            // Register the done signal for one clock pulse
            done <= done_next;
        end
    end

endmodule